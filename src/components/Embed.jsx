import React from "react";
import LoadingIframe from "react-loading-iframe";

export default function Embed() {
  return (
    <LoadingIframe
      skeleton={
        <div className="default-embed-size embed-b">
          <div className="centered">
            <h2>Loading...</h2>
          </div>
        </div>
      }
      src="https://airtable.com/embed/shr4SJcuhnfPBKLXo?backgroundColor=red"
      className="default-embed-size embed-b"
      frameBorder={0}
      width="100%"
      height="700px"
    />
  );
}
