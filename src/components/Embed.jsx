import React from "react";

export default function Embed({ src, text = "Loading..." }) {
  return (
    <div className="relative w-96 h-96">
      <iframe src={src} className="w-screen h-96"></iframe>
    </div>
  );
}


/*
<LoadingIframe
  skeleton={
    <div className="default-embed-size default-skeleton embed-b absolute relative">
      <div className="centered absolute">
        <div id="spinner"></div>
        <h2>{text}</h2>
      </div>
    </div>
  }
  src={src}
  className="default-embed-size embed-b"
  width="100%"
  height="700px"
/>
*/