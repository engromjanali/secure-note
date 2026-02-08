import React from "react";

const usHistoryData = [
  {
    title: "Colonization & Independence",
    description:
      "European colonization began in the early 17th century, leading to the formation of thirteen colonies under British rule. Conflicts over taxation and governance sparked the American Revolution, resulting in independence in 1776 and the creation of the US Constitution in 1787.",
  },
  {
    title: "Expansion & Civil War",
    description:
      "During the 19th century, westward expansion expanded the nation’s territory but intensified divisions over slavery. These conflicts led to the Civil War, which preserved the Union and abolished slavery.",
  },
  {
    title: "Industrial Growth",
    description:
      "After the war, rapid industrialization reshaped the economy and society. Reform movements emerged to address inequality and improve social conditions across the nation.",
  },
  {
    title: "Global Power & Modern Challenges",
    description:
      "In the 20th century, the United States emerged as a global power through World Wars I and II. In recent decades, challenges such as political division, climate change, and social inequality continue to shape the nation.",
  },
];

const TitlePage = () => {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-200 to-purple-300 px-6 py-6">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-2xl lg:text-3xl font-bold text-center mb-8 pt-8 lg:pt-0 text-black">
          History of the United States
        </h1>

        <div className="space-y-10 lg:space-y-6">
          {usHistoryData.map((item, index) => (
            <div
              key={index}
              className=" bg-white p-6 rounded-xl shadow"
            >
              <h2 className="text-xl text-blue-400 font-semibold mb-2">
                {item.title}
              </h2>
              <p className="text-gray-700 leading-relaxed line-clamp-2">
                {item.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default TitlePage;
