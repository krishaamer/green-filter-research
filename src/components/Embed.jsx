import React from "react";
import LoadingIframe from "react-loading-iframe";

export default function Embed({ src }) {
  return (
    <LoadingIframe
      skeleton={
        <div className="default-embed-size embed-b">
          <div className="centered">
            <h2>Loading...</h2>
          </div>
        </div>
      }
      src={src}
      className="default-embed-size embed-b"
      frameBorder={0}
      width="100%"
      height="700px"
    />
  );
}
