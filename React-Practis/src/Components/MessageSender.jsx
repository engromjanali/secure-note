import React, { useState } from "react";
import axios from "axios";
import Swal from "sweetalert2";

const MessageSender = () => {
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();

    const todayDate = new Date()
      .toLocaleDateString("en-GB")
      .split("/")
      .join("-");

    const url = `https://note-dd0cc-default-rtdb.firebaseio.com/messages/${todayDate}.json`;

    setLoading(true);

    try {
      await axios.post(url, { data: message });

      Swal.fire({
        icon: "success",
        title: "Sent!",
        text: "Your message has been saved ✨",
        timer: 1500,
        showConfirmButton: false,
      });

      setMessage("");
    } catch (error) {
      Swal.fire({
        icon: "error",
        title: "Oops!",
        text: "Something went wrong 😢",
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-200 to-purple-300 px-4">
      <div className="w-full max-w-md bg-white rounded-2xl shadow-xl p-6">
        
        {/* Header */}
        <div className="text-center mb-6">
          <h2 className="text-2xl font-bold text-gray-800">
            💬 Send Message
          </h2>
          <p className="text-sm text-gray-500 mt-1">
            Save your note for today
          </p>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="space-y-5">
          <textarea
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            placeholder="Write your message here..."
            rows={4}
            className="w-full text-black p-4 border border-gray-300 rounded-xl
              focus:outline-none focus:ring-2 focus:ring-blue-500
              resize-none transition"
          />

          <button
            type="submit"
            disabled={loading || !message.trim()}
            className={`w-full py-3 rounded-xl text-white font-semibold transition-all duration-300
              ${
                loading || !message.trim()
                  ? "bg-gray-400 cursor-not-allowed"
                  : "bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700"
              }`}
          >
            {loading ? "Sending..." : "Send Message 🚀"}
          </button>
        </form>

        {/* Footer */}
        <p className="text-center text-xs text-gray-400 mt-6">
          Button disabled if input is empty
        </p>
      </div>
    </div>
  );
};

export default MessageSender;
