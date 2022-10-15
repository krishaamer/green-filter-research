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
    title: "Shop",
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
        Understand who produces the products you buy and what are some greener
        alternatives.
      </>
    ),
  },
  {
    title: "Save",
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
        Get daily insights on how you can do better and focus on what matters.
      </>
    ),
  },
  {
    title: "Invest",
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
        Talk to your green companion to understand where your
        money goes and what it does.
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
