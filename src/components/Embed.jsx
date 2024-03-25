import React from "react";

export default function Embed({ src, text = "Loading..." }) {
  return (
    <div className="h700 w100p">
      <iframe src={src} className="h700 w100p"></iframe>
    </div>
  );
}
