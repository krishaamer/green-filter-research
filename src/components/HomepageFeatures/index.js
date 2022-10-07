import React from "react";
import clsx from "clsx";
import Link from "@docusaurus/Link";
import styles from "./styles.module.css";
import Lottie from "lottie-react";
import easy from "./easy.json";
import carrot from "./carrot.json";
import dragon from "./dragon.json";

const FeatureList = [
  {
    title: "Easy to Use",
    img: (
      <Lottie
        animationData={easy}
        loop={true}
        className={styles.featureSvg}
        role="img"
      />
    ),
    description: (
      <>
        An app designed from the ground up to be used daily and get your
        eco-friendly lifestyle up and running quickly
      </>
    ),
  },
  {
    title: "Focus on What Matters",
    img: (
      <Lottie
        animationData={carrot}
        loop={true}
        className={styles.featureSvg}
        role="img"
      />
    ),
    description: (
      <>
        Connect your shopping and investing data to get daily sustainability
        insights on how you can do better
      </>
    ),
  },
  {
    title: "No Time Wasted",
    img: (
      <Lottie
        animationData={dragon}
        loop={true}
        className={styles.featureSvg}
        role="img"
      />
    ),

    description: (
      <>
        Talk to your green companion 5 minutes per day to understand where your
        money goes and what are some greener alternatives
      </>
    ),
  },
];

function Feature({ img, title, description }) {
  return (
    <div className={clsx("col col--4")}>
      <div className="text--center">{img}</div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
