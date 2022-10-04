import React from "react";
import Image from "@theme/IdealImage";

export default function Figure({ src, caption, refURL = "", refTitle = "" }) {
  return (
    <figure>
      <Image img={src} alt={caption} />
      <figcaption>
        {`${caption}.`}
        {refURL && (
          <>
            {` Photo Credit: `}
            <a href={refURL} target="_blank">
              {refTitle}
            </a>
            {`.`}
          </>
        )}
      </figcaption>
    </figure>
  );
}
