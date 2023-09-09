import React from "react";
import clsx from "clsx";
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
    description: <>Understand who, where, and how makes the products you buy every day</>,
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
        Focus your pension fund on climate, biodiversity, air, water, soil, and
        quality of life
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

    description: <>Begin choosing companies with green credentials and avoid polluters</>,
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
