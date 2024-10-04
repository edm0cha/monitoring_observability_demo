import { useState, useEffect } from "react";
import { PlusIcon } from "@heroicons/react/20/solid";

const API_URL = import.meta.env.VITE_API_URL;

function App() {
  const [message, setMessage] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [conversation, setConversation] = useState<any[]>([]);
  const [items, setItems] = useState<any[]>([]);
  const [session_id, setSessionId] = useState("");
  // const [environment, setEnvironment] = useState("development");

  const fetchItems = async () => {
    const response = await fetch(`${API_URL}/items`, {
      headers: {
        "Content-Type": "application/json",
        "Session-Id": session_id,
        // "Environment": environment
      }
    });
    const data = await response.json();
    if (response.ok) {
      setItems(data);
    } else {
      alert(data.message)
    }
  }

  // Added a unique session id for connection
  const uid = function () {
    return Date.now().toString(36) + Math.random().toString(36).slice(2);
  };

  useEffect(() => {
    fetchItems();
    if (!session_id) {
      setSessionId(uid());
    }
  }, [])

  const sendMessage = async () => {
    setIsLoading(true);
    setConversation([...conversation, { content: message, role: "user" }, { content: null, role: "system" }]);

    // Send Session ID per Request
    const response = await fetch(`${API_URL}/items`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Session-Id": session_id,
        // "Environment": environment,
      },
      body: JSON.stringify({
        item: message
      }),
    });
    if (response.ok) {
      fetchItems();
    } else {
      const data = await response.json();
      alert(data.message)
    }
    setMessage("");
    setIsLoading(false);
  }

  const handleKeypress = (e: any) => {
    // Triggers by pressing the enter key
    if (e.keyCode == 13 && !e.shiftKey) {
      sendMessage();
      e.preventDefault();
    }
  };

  return (
    <div className="isolate bg-white px-6 py-16 sm:py-20 lg:px-8">
      <div
        className="absolute inset-x-0 top-[-10rem] -z-10 transform-gpu overflow-hidden blur-3xl sm:top-[-20rem]"
        aria-hidden="true"
      >
        <div
          className="relative left-1/2 -z-10 aspect-[1155/678] w-[36.125rem] max-w-none -translate-x-1/2 rotate-[30deg] bg-gradient-to-tr from-[#003087] to-[#fff] opacity-30 sm:left-[calc(50%-40rem)] sm:w-[72.1875rem]"
          style={{
            clipPath:
              'polygon(74.1% 44.1%, 100% 61.6%, 97.5% 26.9%, 85.5% 0.1%, 80.7% 2%, 72.5% 32.5%, 60.2% 62.4%, 52.4% 68.1%, 47.5% 58.3%, 45.2% 34.5%, 27.5% 76.7%, 0.1% 64.9%, 17.9% 100%, 27.6% 76.8%, 76.1% 97.7%, 74.1% 44.1%)',
          }}
        />
      </div>
      <div className="mx-auto max-w-2xl text-center">
        <h2 className="text-2xl font-bold tracking-tight text-gray-900 sm:text-4xl">Observability & Monitoring</h2>
        <p className="text-xl text-gray-600 py-5">TODO List</p>
        <div className="grid gap-x-4 gap-y-6 sm:grid-cols-2">
          <div className="sm:col-span-2 flex flex-col w-full py-2 flex-grow md:py-3 md:pl-4 relative border bg-white border-gray-900/50 text-black :bg-gray-700 rounded-md shadow-[0_0_15px_rgba(0,0,0,0.10)]">
            <textarea
              value={message}
              tabIndex={0}
              disabled={isLoading}
              style={{
                height: "24px",
                maxHeight: "200px",
                overflowY: "hidden",
              }}
              placeholder="Send a message..."
              className="m-0 w-full resize-none border-0 bg-transparent p-0 pr-7 focus:ring-0 focus-visible:ring-0 pl-2 md:pl-0"
              onChange={(e) => setMessage(e.target.value)}
              onKeyDown={handleKeypress}
            ></textarea>
            <button
              disabled={isLoading || message?.length === 0}
              onClick={sendMessage}
              className="absolute p-1 rounded-md bottom-1.5 md:bottom-2.5 bg-gray-600 disabled:bg-gray-500 bg-user-message right-1 md:right-2 disabled:opacity-40"
            >
              <PlusIcon className="h-6 w-6 text-white" />
            </button>
          </div>
          {/* <div className="sm:col-span-2 flex flex-col w-full py-2 flex-grow md:py-3 md:pl-4 relative border bg-white border-gray-900/50 text-black :bg-gray-700 rounded-md shadow-[0_0_15px_rgba(0,0,0,0.10)]">
            <input
              value={environment}
              disabled={isLoading}
              style={{
                height: "24px",
                maxHeight: "200px",
                overflowY: "hidden",
              }}
              onChange={(e) => setEnvironment(e.target.value)}
              className="m-0 w-full resize-none border-0 bg-transparent p-0 pr-7 focus:ring-0 focus-visible:ring-0 pl-2 md:pl-0"
            />
          </div> */}
        </div>
        <table className="table-auto w-full mt-5">
          <thead>
            <tr>
              <th className="px-4 py-2">Id</th>
              <th className="px-4 py-2">Item</th>
            </tr>
          </thead>
          <tbody>
            {items.map((item, index) => (
              <tr key={index}>
                <td className="border px-4 py-2">{item.id}</td>
                <td className="border px-4 py-2">{item.item}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}

export default App
