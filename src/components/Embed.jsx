import React from "react";
import LoadingIframe from "react-loading-iframe";

export default function Embed({ src, text = "Loading..." }) {
  return (
    <div className="relative h700">
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
        frameBorder={0}
        width="100%"
        height="700px"
      />
    </div>
  );
}
