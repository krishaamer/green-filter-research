import React from "react";
import Iframe from "react-iframe";
import LoadingIframe from "react-loading-iframe";

export default function Embed({ src, text = "Loading..." }) {
  return (
    <Iframe
      url={src}
      loading="lazy"
      id=""
      display="block"
      position="relative"
      lassName="default-embed-size embed-b"
      frameBorder={0}
      width="100%"
      height="700px"
    />
  );
}
