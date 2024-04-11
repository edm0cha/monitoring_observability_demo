
resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = var.name
  dashboard_body = jsonencode({
    "widgets" : [
      {
        "type" : "metric",
        "height" : 5,
        "width" : 10,
        "y" : 0,
        "x" : 0,
        "properties" : {
          "metrics" : [
            ["AWS/Lambda", "Invocations", "FunctionName", var.function_name, { "id" : "invokes", "label" : "Total Requests" }],
            ["AWS/Lambda", "Duration", "FunctionName", var.function_name, { "id" : "duration", "label" : "Average Response Time", "stat" : "Average" }],
            ["AWS/Lambda", "Errors", "FunctionName", var.function_name, { "id" : "invoke_errors", "visible" : false }],
            ["AWS/Lambda", "Url4xxCount", "FunctionName", var.function_name, { "id" : "errors_400", "visible" : false }],
            ["AWS/Lambda", "Url5xxCount", "FunctionName", var.function_name, { "id" : "errors_500", "visible" : false }],
            [{ "label" : "Total Errors", "color" : "#d62728", "expression" : "invoke_errors + errors_400 + errors_500", "id" : "total_errors" }],
            [{ "label" : "Sucess Rate (%)", "color" : "#2ca02c", "expression" : "100 - ((total_errors/invokes) * 100)", "id" : "sucess_rate" }]
          ],
          "title" : "Items Backend",
          "region" : var.region,
          "stat" : "Sum",
          "view" : "singleValue",
          "setPeriodToTimeRange" : true
        }
      },
      {
        "height" : 5,
        "width" : 7,
        "y" : 0,
        "x" : 10,
        "type" : "metric",
        "properties" : {
          "view" : "timeSeries",
          "stacked" : true,
          "metrics" : [
            ["AWS/DynamoDB", "ConsumedWriteCapacityUnits", "TableName", var.dynamodb_table_name, { "label" : "Written Objects", "color" : "#ff7f0e" }],
            ["AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", var.dynamodb_table_name, { "label" : "Read Objects", "color" : "#2ca02c" }]
          ],
          "title" : "DynamoDB Read / Write Capacity",
          "region" : var.region,
          "setPeriodToTimeRange" : true
        }
      },
      {
        "height" : 5,
        "width" : 6,
        "y" : 0,
        "x" : 17,
        "type" : "metric",
        "properties" : {
          "metrics" : [
            ["AWS/DynamoDB", "ConsumedWriteCapacityUnits", "TableName", var.dynamodb_table_name, { "color" : "#ff7f0e", "label" : "Written Objects" }],
            ["AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", var.dynamodb_table_name, { "color" : "#2ca02c", "label" : "Read Objects" }]
          ],
          "view" : "pie",
          "region" : var.region,
          "stat" : "SampleCount",
          "setPeriodToTimeRange" : true,
          "title" : "DynamoDB Read/Write Comparison (%)"
        }
      },
      {
        "height" : 5,
        "width" : 10,
        "y" : 5,
        "x" : 0,
        "type" : "log",
        "properties" : {
          "query" : "SOURCE '/aws/lambda/${var.function_name}' | fields @timestamp, @message, @logStream, @log\n| filter is_palindrome=1\n| stats count() as PalindromeWords by bin(5m)",
          "region" : var.region,
          "stacked" : false,
          "view" : "bar",
          "setPeriodToTimeRange" : true,
          "title" : "Palindrome Items"
        }
      },
      {
        "height" : 5,
        "width" : 7,
        "y" : 5,
        "x" : 10,
        "type" : "metric",
        "properties" : {
          "metrics" : [
            ["ServerlessTodoList", "CreatedItem", "service", "todo-list"],
            ["ServerlessTodoList", "ListedItems", "service", "todo-list"]
          ],
          "region" : var.region,
          "view" : "gauge",
          "stat" : "Sum",
          "setPeriodToTimeRange" : true,
          "sparkline" : false,
          "trend" : false,
          "stacked" : true,
          "title" : "Created and Listed Items Quota",
          "yAxis" : {
            "left" : {
              "min" : 1,
              "max" : 200
            }
          }
        }
      }
    ]
  })
}
