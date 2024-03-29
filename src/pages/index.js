import React from "react";
import clsx from "clsx";
import Link from "@docusaurus/Link";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import HomepageFeatures from "@site/src/components/HomepageFeatures";
import styles from "./index.module.css";

function HomepageHeader() {
  return (
    <header className={clsx("hero hero--primary", styles.heroBanner)}>
      <div className="container">
        <h1 className="hero__title">
          Shop, save and invest with your mind at ease from climate anxiety 😊
        </h1>
        <p className="hero__subtitle">
          Green Filter helps you see your money through the lens of
          sustainability
        </p>
        <div className={styles.buttons}>
          <Link
            className="button button--primary button--lg"
            to="/research/abstract"
          >
            Read Research
          </Link>
        </div>
      </div>
    </header>
  );
}

export default function Home() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      title={`${siteConfig.title}`}
      description="What if sustainability was an app?"
    >
      <div className="home">
        <HomepageHeader />
        <main className="home-main">
          <HomepageFeatures />
        </main>
      </div>
    </Layout>
  );
}
