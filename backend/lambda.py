import os
import json
import boto3

from pydantic import BaseModel, Field
from langchain.chains import LLMChain
from langchain.llms.bedrock import Bedrock
from langchain.prompts import PromptTemplate
from langchain.output_parsers import PydanticOutputParser, OutputFixingParser

BEDROCK_CLIENT = boto3.client("bedrock-runtime")

class Response(BaseModel):
    message: str = Field(..., title="Put here your response")
    score: float = Field(..., title="Put here the score on how close you are to close a sell based on the user question and your response for 0 to 1, where 1 is the best score.")

PROMPT_TEMPLATE = """You represent to a sells company named Amazon and your goal is to answer any question about a list of products.
you should aim at the end if you can assists the user to complete an order and sell a product. 
if there is a complain ask user to contact support team.
{format_instructions}
"""

def getAnswer(question, sessionId):
    print("Ask Chatbot for an answer")
    try:
        llm = Bedrock(
            client=BEDROCK_CLIENT,
            model_id="anthropic.claude-v2",
            model_kwargs={
                "max_tokens_to_sample": 2048,
                "temperature": 0.9,
                "top_k": 250,
                "top_p": 0.99,
                "stop_sequences": ["\n\nHuman:"]
            }
        )
        parser = PydanticOutputParser(pydantic_object=Response)
        chain = LLMChain(llm=llm, prompt=PromptTemplate(
            template=PROMPT_TEMPLATE,
            input_variables=[],
            partial_variables={"format_instructions": parser.get_format_instructions()},
            output_parser=PydanticOutputParser(pydantic_object=Response)
        ))
        result = chain.invoke({"question": question})
        response = parser.parse(result['text']).model_dump()
        print(response['score'])
    except Exception as e:
        print(f"Error: {str(e)}")
        response = {"message": "Sorry, try again!"}
    return response

def setResponse(response, message, statusCode):
    response.update(statusCode=statusCode)
    response.update(body=json.dumps(message))

def lambda_handler(event, _):
    response = {
        "headers": {
            "Content-Type": "application/json"
        }
    }
    try:
        request_body = json.loads(event["body"])
        question = request_body.get("question", "")
        body_response = getAnswer(question, event["headers"]["session-id"])
        setResponse(response, body_response, 200)
        print("successfully completed")
    except Exception as e:
        setResponse(response, {"message": str(e)}, 500)
    return response

if __name__ == "__main__":
    print(getAnswer("I have a complain about a product!", ""))
