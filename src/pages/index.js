import React from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import styles from './index.module.css';

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={clsx("hero hero--primary", styles.heroBanner)}>
      <div className="container">
        <h1 className="hero__title">Green Filter</h1>
        <p className="hero__subtitle">
          Find Sustainable Companies
        </p>
        <div className={styles.buttons}>
          <Link
            className="button button--secondary button--lg"
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
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout
      title={`${siteConfig.title}`}
      description="What if sustainability was an app?"
    >
      <HomepageHeader />
      <main className="home-main">
        <HomepageFeatures />
      </main>
    </Layout>
  );
}
