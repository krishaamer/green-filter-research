---
title: Introduction
bibliography: [ref.bib]
csl: apa.csl
sidebar_position: 2
editor:
    render-on-save: false
---

``` mdx-code-block
import Figure from "/src/components/Figure";
import Susan from "./images/susan-pink-app.png";
import Tricorder from "./images/tricorder.jpg";
import Geneve from "./images/geneve.jpg";
import Boundaries from "./images/boundaries.png";
```

# Introduction {#introduction}

Consumer lifestyle contributes to environmental destruction. Ellen MacArthur Foundation’s models show 45% of CO2e emissions come from our daily shopping, produced by companies that make the products we consume (Ellen MacArthur Foundation, Material Economics (2019)). While people express eco-conscious ideas, it’s non-trivial to practice sustainability in daily life. Oboarding more people for sustainabile practicies is a complex interaction design issue hindered by ambiguous data (what is sustainable?) and messy human motivations (we love buying things).

Health tracking apps paired with connected devices such as Apple Watch filled with sensors provide one model of simple interactions to build a **quantified self** in a dynamically track health data. This data allows apps to provide tips how to improve health outcomes through small daily actions such as climbing more stair or drinking more water. Small interactions allow users to align their value with their actions.

What would be a good interface to track sustainability?

## The Policy Context in Europe From 2023 to 2030 {#the-policy-context-in-europe-from-2023-to-2030}

In 2019 by the von der Leyen commission adopted the European Union (EU) **Green Deal** strategy. In 2021 the Commision proposed a goal of reducing CO2e emissions by 55% by 2030 under the *Fit for 55* policy package consisting of a wide range of economic measures. In November 2022, the proposal was adopted by the EU Council and EU Parliament with an updated goal of 57% of CO2e reductions compared to 1990. This proposal is set to become a binding law for all EU member countries (European Commission (2019b); European Commission (2019a); *EU Reaches Agreement on National Emission Reductions* (2022); European Council (2022)).

## Ecodesign as Key Policy Tool {#ecodesign-as-key-policy-tool}

In March 2022, the EU Circular Economy Action Plan was adopted, looking to make sustainable products *the norm* in EU and *empowering consumers* as described in European Commission (2022). Each product covered by the policy is required to have a ***Digital Product Passport*** which enables improved processing within the supply chain and includes detailed information to empower consumers to understand the environmental footprint of their purchases. It’s safe to say the large majority of products available today do not meet these criteria. A large part of the proposal by Commission et al. (2014) is ***ecodesign***, as a large part of product lifecycle environmental impact is defined in the design process.

| Quality    |                   |                    |
|------------|-------------------|--------------------|
| Durable    | Reparable         | Easy to recycle    |
| Reusable   | Easy to maintain  | Energy efficient   |
| Upgradable | Easy to refurbish | Resource efficient |

The framework proposes 9 values to strive for in high quality products.

## Relevance {#relevance}

-   and protecting biodiversity

This research is timely in 2023 because of the convergence of four trends:

-   Youth demand for sustainability
-   Intergenerational money transfer to the youth
-   AI user interface availability
-   ESG instruments
-   The current environmental upheaval, led by Generation Z, followed by Millennials, and the business adaptation (or lack thereof) to sustainable economic models, taking into account the hidden social and environmental costs we didn’t calculate in our pricing before. The award-winning economist Mariana Mazzucato argues we have to include more into how we value unpaid labor (in Gupta (2020)), relating to the social (S in ESG).
-   We also need to consider environmental effects (E in ESG). We haven’t taken into account the whole cost of production, leading to the wrong pricing information. To achieve this, we need expert governance (G).

**There’s evidence young people have money:**

-   In the U.S. alone, the combined annual consumer spending of Millennials and Gen-Z was over 2.5T USD in 2020 (see YPulse (2020)).
-   Over the coming decade, in the U.S., UK, and Australia, Millennials are inheriting 30T USD from their parents (Calastone (2020)).

**Mainstream technology penetration worldwide**

-   80% of world population has a smartphone according to BankMyCell (2022) while 98% of Generation Z owns smartphone Global Web Index (2017)

-   The latest IPCC report

-   Only 30% believe tech can solve all problems. https://review42.com/resources/gen-z-statistics/

-   https://www.pewresearch.org/fact-tank/2019/01/17/where-millennials-end-and-generation-z-begins/

-   kora 95%

## Research Background {#research-background}

I grew up reading science fiction books in the 1990s and their influence on my outlook towards future possibilities continues until present day. Star Trek has a portable device called a ***tricorder*** (fig. 1), which enables imagined future humans fix all kinds of problems from scanning for minerals inside a cave to scanning human bodies for medical information. I would love to have such a device for consumer choices and financial decisions - to know what to buy and which businesses to do business with. Robots are already part of our lives; this thesis proposal was partially written using Google’s and Apple’s Voice recognition software, allowing me to transcribe notes with the help of an AI assistant.

``` mdx-code-block
<Figure
  caption="Climate protest in Geneva on 27th September, 2019"
  src={Geneve}
  refURL="https://commons.wikimedia.org/wiki/File:Gr%C3%A8veClimatGen%C3%A8ve-27sept2019-041-RuesBasses.jpg"
  refTitle="Wikimedia Commons"
/>
```

As a foreigner living in Taiwan, I’ve relied extensively on Google Maps’ AI assistant to move around efficiently, including to find food and services, when writing in Chinese, Apple’s text prediction translates pinyin to hanzi. Even when we don’t realize it, AI assistants are already helping us with many mundane tasks. While it takes incredibly complex computational algorithms to achieve this in the background, it’s become so commonplace, we don’t even think about it. From this point of view, another AI assistant to help us with greener shopping decisions linked to eco-friendly investing doesn’t sound so much of a stretch.

``` mdx-code-block
<Figure
  caption="Figure 1: Captain Sulu using a Tricorder (Star Trek) - Photo copyright by Paramount Pictures"
  src={Tricorder}
/>
```

In 1896, the Nobel Prize winner Svante Arrhenius first calculated how an increase in CO2 levels would have a warming effect on our global climate. 120 years later, in 2016, the Paris Agreement came into effect, with countries agreeing on non-binding climate targets, which a majority of countries are failing to meet. In August 2018, Greta Thunberg skipped school to start a climate strike in front of the Swedish parliament Riksdag. Millions of people joined Fridays for Future protests around the world (Deutsche Welle (2019)) and Time magazine named Thunberg person of the year in 2019 for *creating a global attitudinal shift* (Time (2019)). While awareness of Earth’s operating systems is growing, the CO2 emissions keep rising.

In January 2022, the Stockholm Resilience Centre reported that humanity had breached 4 out of our 9 planetary boundaries ((**OutsideSafeOperating?**)). In addition to climate change, biodiversity loss, land-system change, and biogeochemical flows. Given these facts, what can people who want to preserve Earth’s human-friendly environment, exactly do? How can networks of people come together to reduce traffic, deforestation, support mobility and green builings? One way to influence societal outcomes is to decide where to put our money. What is the user interface at scale, useful for billions of diverse users to make a meaningful impact? While our financial decisions are a vote towards the type of businesses we want to support, it’s not enough to ***switch to green***.

For the average person, our experience is limited with buying things at the supermarket. Food, clothes, furniture, soap, mobile phone.

-   Green Supermarket
-   Green Savings
-   Green Investing

``` mdx-code-block
<Figure
  caption="Planetary Boundaries"
  src={Boundaries}
  refURL="https://www.stockholmresilience.org/research/planetary-boundaries.html"
  refTitle="J. Lokrantz/Azote based on Steffen et al. 2015"
/>
```

## Research Motivation {#research-motivation}

First, while young people are demanding sustainability, and progressive governments and companies are increasingly announcing green investment opportunities, how can consumers discover the most suitable investment options for their situation? How can potential sustainability-focused retail investors access and differentiate between eco-friendly investable assets? The level of knowledge of and exposure to investing varies widely between countries. According to a Calastone study surveying 3000 ‘Millennial’ people between ages 23 and 35 in Europe (UK, France, Germany), U.S.A., Hong Kong, and Australia, 48% of respondents located in Hong Kong owned financial securities (such as stocks or shares) in comparison with just 10% in France (Calastone (2020)).

Secondly, could linking green consumption patterns with sustainable investing provide another pathway to speed up achieving climate justice as well as personal financial goals? For example, in this simplified scenario, I’m in a physical offline store, doing some shopping. When putting a bottle of Coca Cola in my basket, my ***financial AI advisor Susan*** (fig. 2, above) will ask me a personalized question (fig. 3):

``` mdx-code-block
<Figure
  caption="Figure 2 - Early prototype of my Sustainable Finance AI Companion"
  src={Susan}
/>
```

AI: “Kris, do you still remember Coca Cola’s packaging is a large contributor to ocean plastic? You even went to a beach cleanup!” Me: “That’s so sad but it’s tasty!” AI. “Remember your values. Would you like to start saving for investing in insect farms in Indonesia instead? Predicted return 4% per annum, according to analysts A and B.” If I’m not so sure, I could continue the conversation. Me: “Tell me more” AI: “A recent UN study says, the planet needs to grow 70% more food in the next 40 years. Experts from 8 investment companies predict growth for this category of assets.” Me: “Thanks for reminding me who I am” … Moments later. AI: “This shampoo is made by Unilever, which is implicated in deforestation in Indonesia according to reporting by World Forest Watch. Would you consider buying another brand instead? They have a higher ESG rating.”

Figure 3: Speculative scenario of an interaction between a human user and a robo-advisor through the interface of chat messages in the context of retail shopping for daily products.

## Research Objective {#research-objective}

Where does our money go and what are some greener alternatives?

This is largely due to the production and manufacturing processes of the companies that make the products we consume on a daily basis.

As people become aware of the impact their shopping is having on the environment, they become interested in finding alternatives to big brands and large companies. GreenFilter provides designers an AI companion design which helps people build relationships with sustainability-focused companies by providing personalized recommendations, giving product reviews and helping them shop sustainably. This new tool will empower consumers to make greener choices throughout their lives.

An AI companion app that seeks to help people build relationships with sustainability-focused companies and enables people to be more transparent and responsible in their consumption behavior.

GreenFilter introduces a novel, interactive point-of-sale technology that helps people make greener shopping decisions. The platform uses artificial intelligence to suggest green alternatives for products on your shopping list, and will also help you to find other companies that can make sustainable versions of the product you are buying.

How can people shop, save & invest sustainably? The study presents an AI companion design which seeks to help people build relationships with sustainability-focused companies. The major contribution of this study is an interactive artefact (a prototype) informed by design research.

Green Filter helps you discover how to save money and the planet with your daily shopping. By providing an easy way for people to learn about and shop with sustainable companies, we imagine a world where people invest in their future, find great deals on responsibly-made products, and get useful discounts from socially responsible brands.

GreenFilter is a product that combines AI, design and marketing to help people manage their social impact throughout the stages of their lives, from young adult years to retirement. Its primary goal is to give people the tools they need to invest responsibly in sustainable companies, while also educating them on this topic. Our project offers a responsive website and mobile app that leverages AI and other advanced technologies. In addition, our prototype includes a reality-based virtual assistant with voice command capabilities which can provide customers with new insights into the world of green finance

-   My thesis is that a lot of people want to do good, shop eco-friendly, invest green, etc. But they don’t believe the solutions work. They don’t have trust. This is a user interface issue. How to build trust.

-   q: “it seems impossible to know which company is more sustainable than the other” we don’t really know what’s green?

-   in their sustainability report every company looks perfect

-   Better management of planet Earth

-   How can wee Shop, Save, Invest in line ecologic principles and planetary boundaries? individual action doesn’t move the needle. how to group together

-   Individual efforts are too small to matter unless they’re inspired by Community a effort

-   App to build community

-   Life within planetary boundaries

-   Currently it seems there’s a secret around how things are produced we want to increase transparency

-   Companies that have nothing new nothing to hide should welcome this opportunity to mark themselves to keep a conscious consumers and investors.

-   We want to create competition around sustainable practices enter widespread adoption

-   Cigarettes and pictures of lung cancer every product should be required to have photos of production conditions switch such as Rainforest and deforestation the products that include Palm oul

## Demographics {#demographics}

-   https://99firms.com/blog/generation-z-statistics/#gref

-   https://review42.com/resources/smartphone-statistics/

-   My interest lies in understanding how AI assistants can help conscious consumers become sustainable investors.

-   The purpose of this study is to explore how to provide the best user experience to potential sustainable financial AI companion users.

-   User survey with potential users, defined as living in Taiwan, in the age range between 18 and 35.

-   Interviews with experts in finance and design, and a including a choice experiment between potential feature sets in consumption, savings, and investment.

Survey respondents:

| Key        | Value    |
|------------|----------|
| Location   | Taiwan   |
| Age        | 18-35    |
| Occupation | Students |

## Research Questions {#research-questions}

-   My research aims to explore the following 3 research questions.

-   What is the UI/UX of the green transformation?

| №   | Question                                                                     | Methods                                     |
|-------|--------------------------------------|----------------------------|
| 1   | How can AI assistants encourage sustainable shopping, saving, and investing? | Literature review + Expert Interviews       |
| 2   | How to design an intuitive sustainable shopping, saving, investing app?      | Literature review + Survey                  |
| 3   | What features do potential app users rate as the highest priority?           | Survey + Prototype Testing with Focus Group |

## References {#references .unnumbered}

BankMyCell. (2022). *How Many People Have Smartphones Worldwide*. https://www.bankmycell.com/blog/how-many-phones-are-in-the-world.

Calastone. (2020). *Millennials and investing: A detailed look at approaches and attitudes across the globe*.

Commission, E., Energy, D.-G. for, Enterprise, D.-G. for, & Industry. (2014). *Ecodesign your future : How ecodesign can help the environment by making products smarter*. European Commission. <https://doi.org/doi/10.2769/38512>

Deutsche Welle. (2019). *Fridays for Future global climate strike*. https://www.dw.com/en/fridays-for-future-global-climate-strike-live-updates/a-50505537.

Ellen MacArthur Foundation, Material Economics. (2019). *Completing the picture: How the circular economy tackles climate change*. https://circulareconomy.europa.eu/platform/en/knowledge/completing-picture-how-circular-economy-tackles-climate-change.

*EU reaches agreement on national emission reductions*. (2022). https://ec.europa.eu/commission/presscorner/detail/en/ip_22_6724.

European Commission. (2019a). *A Sustainable Europe by 2030*. https://ec.europa.eu/info/publications/reflection-paper-towards-sustainable-europe-2030_en.

European Commission. (2022). *Circular Economy Action Plan: For a cleaner and more competitive Europe*.

European Commission. (2019b). *The European Green Deal*.

European Council. (2022). *Fit for 55 - The EU’s plan for a green transition*. https://www.consilium.europa.eu/en/policies/green-deal/fit-for-55-the-eu-plan-for-a-green-transition/.

Global Web Index. (2017). *98% of Gen Z Own a Smartphone*. https://blog.gwi.com/chart-of-the-day/98-percent-of-gen-z-own-a-smartphone/.

Gupta, A. H. (2020). An “Electrifying” Economist’s Guide to the Recovery. *The New York Times*.

Time. (2019). *Greta Thunberg: TIME’s Person of the Year 2019*. https://time.com/person-of-the-year-2019-greta-thunberg/.

YPulse. (2020). *Millennials & Gen Z Teens’ Combined Spending Power Is Nearly \$3 Trillion in 2020*. https://www.ypulse.com/article/2020/01/09/millennials-gen-z-teens-combined-spending-power-is-nearly-3-trillion-in-2020/.
