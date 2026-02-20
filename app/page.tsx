import React from "react";

function GridContainer({ children}: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen min-w-screen relative">
      <div className="h-full w-0.5 bg-gray-400 absolute z-20 top-0 left-[40px]  opacity-40  "></div>
      <div className="h-full w-0.5 bg-gray-400 absolute z-20 top-0 right-[40px]  opacity-40 "></div>
      <div className="h-0.5 w-screen bg-gray-400 absolute z-20 top-10 opacity-40 "></div>
      <div className="w-full h-full absolute px-10 pt-10">
        {children}
      </div>

    </div>
  );
}

export default function Home() {
  return (
    <GridContainer>
      <div className="max-w-3xl mx-auto pt-10 text-center ">
        Welcome to portfolio website
      </div>

    </GridContainer>

  );
}
