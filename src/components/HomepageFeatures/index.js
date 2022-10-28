import React from "react";
import clsx from "clsx";
import styles from "./styles.module.css";
import Lottie from "lottie-react";
import easy from "./easy.json";
import carrot from "./carrot.json";
import dragon from "./dragon.json";

const FeatureList = [
  {
    title: "Shop Green",
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
        alternatives
      </>
    ),
  },
  {
    title: "Save Nature",
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
        Learn how your money can conserve a biodiverse environment and focus on what
        matters
      </>
    ),
  },
  {
    title: "Invest Eco",
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
        See where your investments go and what type of companies you're supporting
      </>
    ),
  },
];

function Feature({ img, title, description }) {
  return (
    <div className={clsx("col col--4")}>
      <div className="text--center">{img}</div>
      <div className="text--center padding-horiz--md">
        <h3 className="feature-title">{title}</h3>
        <p className="feature-desc">{description}</p>
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
