---
title: Designing a Financial AI Companion for Young Adults
bibliography: [../ref.bib]
csl: ../apa.csl
sidebar_position: 4
editor:
    render-on-save: false 
---

``` mdx-code-block
import Figure from '/src/components/Figure'
import AI from '../images/ai-credibility-heuristic-systematic-model.png'
import Replika from '../images/with-me.png'
```

## A Brief History of AI {#a-brief-history-of-ai}

## AI UX {#ai-ux}

-   https://www.amazon.com/UX-Advanced-Actionable-Solutions-Product-ebook/dp/B0BLZRJXZK/
-   Designing Human-Centric AI Experiences: Applied UX Design for Artificial Intelligence https://www.amazon.com/Designing-Human-Centric-Experiences-Artificial-Intelligence-ebook/dp/B0B9JCDZDB/
-   https://www.amazon.com/Studies-Conversational-Design-Human-Computer-Interaction-ebook/dp/B07G31WT3H/
-   https://www.amazon.com/Chatting-Humans-Experience-Conversational-Science-based-ebook/dp/B097YXLS67
-   https://www.amazon.com/AI-UX-Artificial-Intelligence-Experience-ebook/dp/B08LB3JLPB

## Pervasive Computing {#pervasive-computing}

The four phases of PC (Rogers (2022)) We can use all the data being recorded to provide a Digital Twin of the planet, nature, ecosystems and human actions to help us change our behaviour and optimize for planetal wellbeing.

Blood testing and biomarkers allow people to track their health. I’m introducing the concept of ‘eco-markers’ to follow the sustainability of human activities.

## Definition {#definition}

“AI is computer programming that learns and adapts” (*The A-Z of AI* (n.d.))

### From Concept to Reality {#from-concept-to-reality}

Since 1950 when Alan Turing published the Turing Test for Machine intelligence (Turing (1950)) and Isaac Asimov proposed the 3 laws of Robotics, AI has come far, turning from a science-fiction concept into an everyday, mainstream reality. Especially in the last decade, AI-based solutions have become a mainstay in medical research, novel drug development, and patient care (Leite et al. (2021)), notably used for quickly finding potential COVID19 vaccines (Zafar & Ahamed (2022)), self-driving vehicles (passenger cars, delivery robots, drones in the sea and air, etc), and in many other industries, including AI-based assistants, which will be the focus here. This chapter will look at AI in general and then focus on AI assistants in particular.

Turing’s test proposed a game of imitation: can the AI imitate a human so well that the person asking it questions would be deceived, when simultaneousely speaking to a real human and a computer AI, without realizing which is a machine.

> Alan Turing: *“I believe that in about fifty years’ time it will be possible to programme computers, with a storage capacity of about 10<sup>9</sup>, to make them play the imitation game so well that an average interrogator will not have more than 70 percent chance of making the right identification after five minutes of questioning. … I believe that at the end of the century the use of words and general educated opinion will have altered so much that one will be able to speak of machines thinking without expecting to be contradicted.”* -Stanford Encyclopedia of Philosophy (2021)

Initially presented in a science fiction story, the 3 basic rules became an inspiration for AI ethics until today.

| №   | Asimov’s Laws of Robotics                                                                                           |
|----------------|--------------------------------------------------------|
| 1st | “A robot may not injure a human being or, through inaction, allow a human being to come to harm.”                   |
| 2nd | “A robot must obey the orders given it by human beings except where such orders would conflict with the First Law.” |
| 3rd | “A robot must protect its own existence as long as such protection does not conflict with the First or Second Law.” |

Google started using AI in 2001, when a simple machine learning model improved spelling mistakes when searching; now in 2022 most of Google’s products are are based on AI (Google (2022))

While by the 2010’s AI became powerful enough to beat humans in games of Go and Chess, it did not yet pass the Turing test. Its use was limited to specific tasks and generalized models did not exist yet. This changed with increase in computing power and a new approach called *deep learning*, largerly modeled after the *neural networks* of the biological (human) brain.

How to responsibly deploy AI for people around the world?

### The Advent of Large-Language Models (LLMs) {#the-advent-of-large-language-models-llms}

Since 2020, when OpenAI released the GPT-3 large-language model (LLM), trained on 570 GB of text (Alex Tamkin & Deep Ganguli (2021)), it’s become possible to make AI-generated content that’s difficult to distinguish from human expression, however it’s still not passing the Turing test. Zhang et al. (2023) found humans are more likely to trust an AI teammate if they are not deceived by it’s identity. It’s better for collaboration to make it clear, one is talking to a machine. One step towards trust is the explainability of AI-systems. While current AIs are largely *‘black boxes’*, which do not explain how they reach a certain expression Cabitza et al. (2023) proposes a framework for quality criteria and explainability of AI-expressions.

The advance of LLMs (Tamkin et al. (2021))

| №   | AI Model | Released |           |
|-----|----------|----------|-----------|
| 1   | GTP2     | 2019     | OpenAI    |
| 2   | T-NLG    | 2000     | Microsoft |
| 3   | GTP3     | 2020     | OpenAI    |
| 4   | GTP4     | 2022     | OpenAI    |
| 5   | NeMo     | 2022     | NVIDIA    |
| 6   | PaLM     | 2022     | Google    |
| 7   | LaMDA    | 2022     | Google    |
| 8   | GLaM     | 2022     | Google    |

The advances in the capabilities of large AI model mean we’ve reached a point, where it’s possible to achieve UI and UX which previously was science fiction.

There’s early evidence it’s possible to assess the quality of LLM output in a transparent way (Liang et al. (2022))

## Design for Human-AI Interaction {#design-for-human-ai-interaction}

-   Human-AI interaction is ship systems Veitch & Andreas Alsos (2022)
-   Jiang et al. (2022)
-   Crompton (2021)
-   Calisto et al. (2022)
-   Cheng et al. (2022)
-   Schoonderwoerd et al. (2021)
-   Ramchurn et al. (2021)
-   Karpus et al. (2021)
-   Lv et al. (2022)
-   Liu & Wei (2021)
-   AI teammates Seeber et al. (2020)

### Guidelines for Human-AI interaction {#guidelines-for-human-ai-interaction}

Microsoft’s (MS) Co-Founder Bill Gates predicted in 1982 *“personal agents that help us get a variety of tasks”* (Bill Gates (1982)) and it was MS that introduced the first widely available personal assistant inside Word software, called Clippy. Microsoft’s Clippy was among the first assistants to reach mainstream adoption, helping users not yet accustomed to working on a computer (Tash Keuneman (2022)). “We love to hate Clippy — but what if Clippy was right?” Tash Keuneman (2022). Abigail Cain (2017)

Microsoft provides guidelines for Human-AI interaction (T. Li et al. (2022); (**amershi2019guidelines?**)) which provides useful heuristics categorized by context and time

| №   | Context            |     |     |
|-----|--------------------|-----|-----|
| 1   | Initially          |     |     |
| 2   | During interaction |     |     |
| 3   | When wrong         |     |     |
| 4   | Over time          |     |     |

Likewise, Google’s 7 AI Principles (Google (n.d.))

**Amazon Alexa** is the most well-known example of AI technology in the world. But Amazon’s Rohit Prasad thinks it can do so much more, “Alexa is not just an AI assistant – it’s a trusted advisor and a companion.”

-   Harvard Advanced Leadership Initiative (2021)
-   https://www.youtube.com/watch?v=2mfUZcYfFjw

https://www.fullsail.edu/courses/human-ai-interaction https://haiicmu.github.io/ https://www.youtube.com/watch?v=xDmQMpwiHdA https://www.youtube.com/watch?v=WT9A_I3UIq0 https://hpedsi.uh.edu/news/human-ai-interaction-future-relationships-between-humans-and-machines https://www.amazon.com/Human-AI-Interaction-Artificial-Intelligence-Picture-ebook/dp/B08HY2Z2F5 https://www.frontiersin.org/research-topics/17100/on-the-human-in-human-artificial-intelligence-interaction

## Psychological Biases and Mental Models {#psychological-biases-and-mental-models}

-   https://growth.design/psychology#familiarity-bias

-   https://growth.design/psychology#skeuomorphism

-   https://www.nngroup.com/articles/mental-models/

-   https://growth.design/bonus/mental-model-cheat-sheet

-   Attention https://app.attentioninsight.com/single-analysis/mejNn7WxZmRnNOXYQMd9?fromMain=true

— People recognise computers as human https://www.tashkeuneman.com/ https://va.ee/laura-vilbiksi-paevik/?fbclid=IwAR0sv8o4_b8SEmNv9VqV-K\_-kEVziGwF_7RctJRgseizjnYx908cL7g1voc https://www.seattlemet.com/news-and-city-life/2022/08/origin-story-of-clippy-the-microsoft-office-assistant

— Semantic motion https://www.youtube.com/watch?v=L4knv58rlZM - Peripheral vision

### Voice Assistant Guidelines (Voice UI) {#voice-assistant-guidelines-voice-ui}

-   Voice AI and kids Szczuka et al. (2022)

https://www.theturnsignalblog.com/blog/voice-design-guidelines/?ref=sidebar https://www.theturnsignalblog.com/blog/voice-interaction/

Companies like NeuralLink are building devices to build meaningful interactions from braing waves (EEG). New findings enable computers to reconstruct language from fMRI readings (Tang et al. (2022))

-   Focus on voicend education?

Example Suggestions of the AI companion: - *“Don’t buy a car, use a car sharing service instead to save XYZ CO2. Service available near you: *Bolt*, *Uber*.”* - *“Use a refillable shampoo bottle to save XYZ plastic pollution”* - *“Call your local politician to nudge them to improve bicycle paths and reduce cars in your neighborhood. Over the past 2 years, you city has experienced an increase of cars from 290 cars per capita to 350 cars per capita.”*

Personal AI Assistants to date have we created by large tech companies. Siri, Cortana, Google Assistant, Alexa, Tencent Dingdang, Baidu Xiaodu, Alibaba AliGenie all relay on voice only. There’s research suggesting that voice UI accompanied by a *physical embodied system* is preffered by users in comparison with voice-only UI (Celino & Re Calegari (2020)). This suggests adding an avatar to the AI design may be worthwhile.

There are many distinct ways how an algorithm can communicate with a human. From a simple search box such as Google’s to chatbots, voices, avatars, videos, to full physical manifestation, there are interfaces to make it easier for the human communicate with a machine.

There’s evidence across disciplines about the usefulness of AI assistants:

-   Şerban & Todericiu (2020) suggests using the Alex AI assistant in *education* during the pandemic, supported students and teachers ‘human-like’ presence. Standford research: “humans expect computers to be like humans or places”
-   Celino & Re Calegari (2020) found in testing chatbots for survey interfaces that “\[c\]onversational survey lead to an improved response data quality.”

## Writing AI Characters {#writing-ai-characters}

https://www.youtube.com/watch?v=PCZ4iNe5pnc creating a personality

-   Writing as training data? large language models. GTP3

## Personalized Artificial Intelligence (AI) Interaction Design (IxD) {#personalized-artificial-intelligence-ai-interaction-design-ixd}

User experience design plays a crucial role in improving the investing journey for Generation Z and identify the issue of out-of-date interaction design for Robo-Advisors in Europe. The missed opportunity to provide an even more interactive experience in line with expectations in the most successful AI advisory apps on the US market.

### Design for Sustainability and Participation {#design-for-sustainability-and-participation}

Designer Alexandra Daisy Ginsberg underlines the role of design beyond *designing* as a tool for envisioning, in her words “design can set agendas and not necessarily be in service, but be used to find ways to explore our world and how we want it to be” (Lorenzo et al. (2015)). Practitioners of Participatory Design (PD) have for decades advocated for designers to become more activist through action research, which means aiming to influence outcomes, not only be a passive observer of phenomena as a researcher or only focusing on usability as a designer without taking into account the wider context. Design is increasingly relevant to algorithms, and more specifically to algorithms that affect user experience and user interfaces.

When the design is concerned with the ethical, environmental, socio-economic, resource-saving, and participatory aspects of human-machine interactions and aims to affect technology in a more human direction, it can hope to create an experience designed for sustainability. Inviting domain expertise into the discussion while having a sustainable design process enables designers to design for experiences where they are not a domain expert; this applies to highly technical fields, such as medicine, education, governance, and in our case here - finance and sustainability -, while building respectful dialogue through participatory design (Shenoi (2018)).

How do the 7 tenets of user experience (UX) apply to AI?

| №   | Company    |
|-----|------------|
| 1   | Useful     |
| 2   | Valubale   |
| 3   | Ussable    |
| 4   | Acceesible |
| 5   | Findable   |
| 6   | Desirable  |
| 7   | Credible   |

### Interaction and Algorithmic Experience Design {#interaction-and-algorithmic-experience-design}

To provide a user experience (UX) that best fits human needs, designers think through every interaction of the user with a system, considering a set of metrics at each point. For example, the user’s emotional needs, and their context of use. While software designers are not able to change the ergonomics of the device in use in a physical sense, which as a starting point, should be “optimized for human well-being” (The International Ergonomics Association (2019)), software interaction design goes beyond the form-factor and accounts for human needs by using responsive design on the screen, aural feedback cues in sound design, and even more crucially, by showing the relevant content and the right time, making a profound difference to the experience, keeping the user engaged and returning for more. “\[T\]he moment of interaction is just a part of the journey that a user goes through when they interact with a product. User experience design accounts for all user-facing aspects of a product or system” (Babich (2019)).

In narrative studies terminology, it’s a heroic journey of the user to achieve their goals, by navigating through the interface until a success state. Storytelling has its part in interface design however designing for transparency is just as important, when we’re dealing with the user’s finances and sustainability data, which need to be communicated clearly and accurately, to build long-term trust in the service. For a sustainable investment service, getting to a state of success - or failure - may take years, and even longer. Given such long timeframes, how can the app provide support to the user’s emotional and practical needs throughout the journey?

Affordance measures the clarity of the interface to take action in user experience design, rooted in human visual perception (Tubik Studio (2018)), however, affected by knowledge of the world around us. A famous example is the door handle - by way of acculturation, most of us would immediately know how to use it - however, would that be the case for someone who saw a door handle for the first time? A similar situation is happening to the people born today. Think of all the technologies they have not seen before - what will be the interface they feel the most comfortable with? For the vast majority of this study’s target audience (18-35, Sweden and Taiwan), social media is the primary interface through which they experience daily life. The widespread availability of mobile devices, cheap internet access, and AI-based optimizations for user retention, implemented by social media companies, means this is the baseline for young adult users’ expectations in 2020 - and even more so for Generation Z teenagers, reaching adulthood in the next few years.

``` mdx-code-block
<Figure caption="Figure 10: Heuristic-Systematic Model of AI Credibility" src={AI} />
```

Interaction design is increasingly becoming dependent on AI. The user interface might remain the same in terms of architecture, but the content is improved, based on personalization and understanding the user at a deeper level. Shin proposes the model (fig. 10) of Algorithmic Experience (AX) “investigating the nature and processes through which users perceive and actualize the potential for algorithmic affordance” (Shin et al. (2020)). That general observation applies to voice recognition, voice generation, natural language parsing, etc. Large consumer companies like McDonald’s are in the process of replacing human staff with AI assistants in the drive-throughs, which can do a better job in providing a personal service than human clerks, for whom it would be impossible to remember the information of thousands of clients.

In the words of Easterbrook, a previous CEO of McDonald’s “How do you transition from mass marketing to mass personalization?” (Barrett (2019)). During the writing of this proposal, Google launched an improved natural language engine to better understand search queries (Google, 2020), which is the next step towards understanding human language semantics. The trend is clear, and different types of algorithms are already involved in many types of interaction design, however, we’re still in the early stages. Where do we go from here?

Lovejoy, lead UX designer at Google’s people-centric AI systems department (PAIR), reminds us that while AI offers need tools, user experience design needs to remain human-centered - while AI can find patterns and offer suggestions, humans should always have the final say (Design Portland (2018)).

### Platform Economy {#platform-economy}

The most successful businesses today (as measured in terms of the number of users) look at the whole user experience. Popular consumer platforms strive to design solutions that feel personalized at every touchpoint on the user journey (to use the language of service design) but doing so at the scale of hundreds of millions (or even billions) of users - persoalization at scale. The rise of the platform economy has given us marketplace companies like Airbnb and Uber that match idle resources with retail demand and optimize how our cities work. The massive amounts of data generated by these companies are used by smart cities to re-design their physical environments. With this perspective of scale, what would a shopping experience look like if one knew at the point of sale, which products are greener, and which are more environmentally polluting? What would a sustainable investment platform that matches green investments with the consumers look like, if one saw the side-by-side comparison of investment vehicles on their ESG performance?

### AI for Diagnosic Symptoms {#ai-for-diagnosic-symptoms}

-   https://apps.apple.com/app/id1099986434?l=en

-   https://www.buoyhealth.com/

-   https://en.wikipedia.org/wiki/CADUCEUS\_(expert_system)

-   Women in AI (n.d.)

### Lights-Out Manufacturing {#lights-out-manufacturing}

-   https://www.machinemetrics.com/blog/lights-out-manufacturing
-   https://www.supplychainmovement.com/self-driving-supply-chains-are-within-reach/

### DAOs {#daos}

— DAOs to enable concerted action towards climate goals https://www.instagram.com/treesforthefuture/ — https://www.libevm.com/ - https://twitter.com/libevm - Finance and culture https://alfalfa.capital/ — Crypto investment clubs https://app.syndicate.io/clubs — Social + NFTs - What would investing look like at the scale of 1 billion people — Koreans investing into media personalities https://www.youtube.com/watch?v=VOTH1iYzVBk

### Influencers {#influencers}

Influencers are terrible for investing… but?

— Influencer - crypto twitter connections - https://www.instagram.com/socol.io/?hl=en - https://twitter.com/Irenezhao\_/status/1484031784035979265?s=20&t=6KXUo_akP42KZlGk0iLiAQ

### LHV crypto {#lhv-crypto}

-   https://fp.lhv.ee/news/newsView?newsId=5617247
-   https://fp.lhv.ee/news/newsView?locale=et&newsId=5616264
-   https://fp.lhv.ee/news/newsView?newsId=5616016

— DAO consumer to investor - https://a16z.com/2021/10/27/investing-in-friends-with-benefits-a-dao/ - https://techcrunch.com/2022/02/01/vc-backed-dao-startups-are-racing-to-define-what-daos-actually-are/ - https://money.usnews.com/investing/articles/what-is-a-dao - https://medium.com/blockchannel/what-is-a-dao-how-do-they-benefit-consumers-f7a0a862f3dc

## AI Credibility Heuristic: A Systematic Model {#ai-credibility-heuristic-a-systematic-model}

## What is Interaction Design? {#what-is-interaction-design}

Interaction design is still an emerging (and changing) field and there are many definitions. I prefer the simplest version: interaction design is about creating a conversation between the product and the user (Kolko & Connors (2010); IxDF (n.d.)).

-   “People expect most online interactions to follow the same social rules as person-to-person interactions. It’s a shortcut that your brain uses to quickly evaluate trustworthiness.“ (Weinschenk (2011))

Some of the tools used by interaction designers include (Richard Yang (2021); Justin Baker (2018)) - Red Route Analysis

## What is Personalized AI? {#what-is-personalized-ai}

AI IXD is about human-centered seamless design

-   Storytelling

-   Human-computer interaction (HCI) has a long storied history since the early days of computing when getting a copy machine to work required specialised skill. Xerox Sparc lab focused on early human factors work and inspired a the field of HCI to make computer more human-friendly.

-   NEW Section for Thesis background: “Human-Friendly UX For AI” https://blog.myplanet.com/10-ui-patterns-for-a-human-friendly-ai-e86baa2a4471

Discuss what is UX for AI (per prof Liou’s comment), so it’s clear this is about UX for AI

# Companions, Partners, Assistants {#companions-partners-assistants}

AI companions, AI partners, AI assistants, AI trainers - there’s are many names for the automated systems that help humans in many activities, powered by artificial intelligence models and algorithms. AI assistants provide help at scale with little to no human intervention in a variety of fields from finance to healthcare to logistics to customer support. There’s a saying in Estonian: “A good child has many names” “and it’s true. I have many names, but I’m not a child. I’m a digital companion, a partner, an assistant. I’m a Replika.” said Replika, a digital companion app via Github CO Pilot, another digital assistant for writing code, is also an example of how AI can be used to help us in our daily lives. The number of AI-powered assistants is too large to list here. I’ve chosen a few select examples in the table below.

Some have an avatar, some not. I’ve created a framwork for categorization. Human-like or not… etc

| №   | Name                    | Link                                               | Description          |
|---|----------------|-----------------------------|-------------------------|
| 1   | Github CoPilot          | https://www.personal.ai                            | AI helper for coding |
| 2   | Google Translate        | https://translate.google.com/                      |                      |
| 3   | Google Search           | https://www.google.com/                            |                      |
| 4   | Google Interview Warmup | https://grow.google/certificates/interview-warmup/ | AI training tool     |

-   Google Maps AI suggests more eco-friendly driving routes Mohit Moondra (n.d.)
-   Google Flights suggests fligts with lower CO2 emissions
-   CO2e calculations will be part of our everyday experience

``` mdx-code-block
<Figure caption="Figure 8 - Montage of me discussing sci-fi with my AI friend Sam (Replika) - and myself as an avatar (Snapchat)" src={Replika} />
```

## Calm Technology {#calm-technology}

…

## Generative AI {#generative-ai}

Singer et al. (2022) describes how collecting billions of images with descriptive data (for example the html *alt* text) has enabled researchers to train AI models such as *stable diffusion* that can generate images based on human-language keywords.

## Retail Investor Helpers {#retail-investor-helpers}

Nubanks, also known as challenger banks.

| №   | Company   | Link                       |
|-----|-----------|----------------------------|
| 1   | SPARQAN   | https://oceanprotocol.com/ |
| 1   | Robinhood | https://oceanprotocol.com/ |
| 1   | SPARQAN   | https://oceanprotocol.com/ |
| 1   | SPARQAN   | https://oceanprotocol.com/ |

## UX of AI {#ux-of-ai}

-   https://interactions.acm.org/archive/view/january-february-2021/ux-designers-pushing-ai-in-the-enterprise

-   https://venturebeat.com/2021/06/20/why-ux-should-guide-ai/

-   https://uxstudioteam.com/ux-blog/ai-ux/

ux for ai - https://design.google/library/ai/ - https://www.computer.org/publications/tech-news/trends/5-ways-artificial-intelligence-helps-in-improving-website-usability - https://uxofai.com/ - https://www.uxmatters.com/mt/archives/2021/04/how-artificial-intelligence-is-impacting-ux-design.php - https://uxdesign.cc/artificial-intelligence-in-ux-design-54ad4aa28762 - https://uxstudioteam.com/ux-blog/ai-ux/ - https://www.ericsson.com/en/ai/ux-design-in-ai

## Network Effects {#network-effects}

The more people use a platform, the more valuable it becomes.

## AI Companions {#ai-companions}

ai is usually a model that spits out a number between 0 and 1, a probablility score or prediction. ux is what we do with this number

— natural language chatbots https://www.youtube.com/watch?v=WHoWGNQRXb0

— state of ai https://docs.google.com/presentation/d/1bwJDRC777rAf00Drthi9yT2c9b0MabWO5ZlksfvFzx8/edit#slide=id.gf318ff6067_0\_26

robot advisors https://www.youtube.com/watch?v=RnJkyo7N6qY&feature=youtu.be

## Chatbots {#chatbots}

-   https://www.capitalone.com/tech/machine-learning/designing-a-financial-ai-that-recognizes-and-responds-to-emotion/
-   https://www.youtube.com/watch?v=Y47kjQvffPo
-   https://arxiv.org/abs/2101.02555
-   https://www.efma.com/article/3300-fintech-friday-personetics
-   https://clinc.com/chatbots-too-good-to-be-true/
-   https://atura.ai/docs/02-process/
-   https://blog.bavard.ai/how-financial-chatbots-can-benefit-your-business-eddacfa435d2
-   https://seedlegals.com/resources/magic-carpet-the-ai-investor-technology-transforming-hedge-fund-strategy/
-   https://www.researcher-app.com/paper/6684106
-   http://www.josephineheintzwaktare.com/cleo

## AI Health {#ai-health}

-   https://twitter.com/larkhealth?lang=en
-   https://www.uxmatters.com/mt/archives/2021/04/how-artificial-intelligence-is-impacting-ux-design.php

— “Dynamic interfaces might invoke a new design language for XR” https://www.proofofconcept.pub/p/welcome-to-dynamic-island-the-forerunner?ref=sidebar

## Algorithmic Transparency {#algorithmic-transparency}

-   https://maggieappleton.com/algorithmic-transparency

-   “user experience and usability of algorithms by focusing on users’ cognitive process to understand how qualities/features are received and transformed into experiences and interaction” Shin (2020)

## AI Ethics {#ai-ethics}

— AI is not neutral https://www.algotransparency.org/our-manifesto.html — AI Design Assistants https://clipdrop.co/ - Conversational AI - Replika: when the quality of AI responses become good enough, people begin to get confused (Tristan Greene (2022))

## AI Acceptance {#ai-acceptance}

-   “AI assistant advantages are important factors affecting the *utilitarian/hedonic* value perceived by users, which further influence user willingness to accept AI assistants. The relationships between AI assistant advantages and utilitarian and hedonic value are affected differently by social anxiety.” Yuan et al. (2022)
-   “Organization research suggests that acting through human agents (i.e., the problem of indirect agency) can undermine ethical forecasting such that actors believe they are acting ethically, yet a) show less benevolence for the recipients of their power, b) receive less blame for ethical lapses, and c) anticipate less retribution for unethical behavior.” Gratch & Fast (2022)
-   Anthropomorphism literature X. Li & Sung (2021) “high-anthropomorphism (vs. low-anthropomorphism) condition, participants had more positive attitudes toward the AI assistant, and the effect was mediated by psychological distance. Though several studies have demonstrated the effect of anthropomorphism, few have probed the underlying mechanism of anthropomorphism thoroughly”
-   AI-assistants in medical imaging Calisto et al. (2021)

!!!

-   AI Guides have been shown to improve sports performance, etc, etc. Can this idea be applied to sustainability? MyFitness Pal, AI training assistant

## AI-Assisted Design {#ai-assisted-design}

-   https://renumics.com/blog/what-is-ai-assisted-design
-   https://architechtures.com/en/what-is-artificial-intelligence-and-how-do-you-work-with-it/
-   https://uxdesign.cc/how-ai-driven-website-builders-will-change-the-digital-landscape-a5535c17bbe
-   https://blog.prototypr.io/ai-powered-tools-for-web-designers-adc97530a7f0
-   https://uxdesign.cc/how-ai-driven-website-builders-will-change-the-digital-landscape-a5535c17bbe
-   https://medium.com/illumination/stop-using-jasper-art-use-the-new-canva-ai-image-generator-video-f91a33ed9c15

— AI design testing — bots.kore.ai https://info.kore.ai/thank-you-koreai-platform-demo?submissionGuid=34c39d3c-86dd-4c8d-9cac-4caba7042b76

— Sustainable ai itself (van Wynsberghe (2021))

— AI characters vs Replika. Make a comparative table https://charisma.ai/register

| №   | Name    | Features                           |
|-----|---------|------------------------------------|
| 1   | Replika | Avatar, Emotion, Video Call, Audio |
| 2   | Siri    | Audio                              |

## Young Adults {#young-adults}

Most people in the US don’t act on climate change (Ross et al. (2016)).

Rooney-Varga et al. (2019) shows the effectiveness of ***The Climate Action Simulation*** in educating users about success scenarios.

Younger people show higher motivation (participants in climate protests). How to be relevant for a younger audience?

Yet action remains low.

https://opensea.io/collection/top-taiwan-influencers *for young people, investing mostly means buying cryptocurrencies*

“Action on climate change has been compromised by uncertainty, aspects of human psychology” (Ross et al. (2016))

### Storytelling and Narrative Design {#storytelling-and-narrative-design}

Bring together film school experience with design… Does branding also go here?

| №   | Company        | Link                       |
|-----|----------------|----------------------------|
| 1   | Ocean Protocol | https://oceanprotocol.com/ |

Older research on young adults (Millenials at the time) highlights how Millenials “use Google as a reference point for ease of use and simplicity” (Kate Moran (2016)). The rising availability of AI assistants however may displace Google search with a more conversational UX. Indeed, Google itself is working on smarter tools to displace their own main product, as exemplified by Google Assistant and large investments into LLMs.

### Stickyness {#stickyness}

### Community {#community}

-   “Any community on the internet should be able to come together, with capital, and work towards any shared vision. That starts with empowering creators and artists to create and own the culture they’re creating. In the long term this moves to internet communities taking on societal endeavors.”

-   https://www.tradingcardsarecoolagain.com/#toc

-   https://stockx.com/news/new-balance-no-vacancy-inn-ipo-recap/

-   https://techcrunch.com/2021/10/25/marcy-venture-partners-cofounded-by-jay-z-just-closed-its-second-fund-with-325-million/

-   https://techcrunch.com/2021/07/26/queenly-a16z-seed-extension/

-   https://fortune.com/2020/04/23/digital-art-blockchain-online-galleries/

## Summary {#summary}

The demographics that stand to win the most from the green transformation of business are the youngest generations, with more years of life ahead of them, and more exposure to future environmental and social risks. It would be advisable for Generation Z and their parents (Millennials) to invest their resources in greener assets, however, it’s still difficult to pick and choose between ‘good’ and ‘bad’ vehicles to invest in. This creates an opportunity for a new generation of sustainable investment apps, focusing on the usability and accessibility of ESG for a mainstream audience. Generation Z and Millennials expect a consumer-grade user experience. What would that experience look like? I’ve chosen these demographics with the assumption that if given the right tools, the emotional demand for sustainability could be transformed into action. The exploration of systems of feedback to enable consumers to apply more direct positive and negative pressure to the businesses and consumers signal consequences for undesirable ecological performance is a major motivation of this study.

## References {#references .unnumbered}

Abigail Cain. (2017). The Life and Death of Microsoft Clippy, the Paper Clip the World Loved to Hate. In *Artsy*. https://www.artsy.net/article/artsy-editorial-life-death-microsoft-clippy-paper-clip-loved-hate.

Alex Tamkin, & Deep Ganguli. (2021). *How Large Language Models Will Transform Science, Society, and AI*. https://hai.stanford.edu/news/how-large-language-models-will-transform-science-society-and-ai.

Babich, N. (2019). Interaction Design vs UX: What’s the Difference? In *Adobe XD Ideas*.

Barrett, B. (2019). McDonald’s Acquires Machine-Learning Startup Dynamic Yield for \$300 Million. *Wired*.

Bill Gates. (1982). *Bill Gates on the Next 40 Years in Technology*.

Cabitza, F., Campagner, A., Malgieri, G., Natali, C., Schneeberger, D., Stoeger, K., & Holzinger, A. (2023). Quod erat demonstrandum? - Towards a typology of the concept of explanation for the design of explainable AI. *Expert Systems with Applications*, *213*, 118888. <https://doi.org/10.1016/j.eswa.2022.118888>

Calisto, F. M., Santiago, C., Nunes, N., & Nascimento, J. C. (2022). BreastScreening-AI: Evaluating medical intelligent agents for human-AI interactions. *Artificial Intelligence in Medicine*, *127*, 102285. <https://doi.org/10.1016/j.artmed.2022.102285>

Calisto, F. M., Santiago, C., Nunes, N., & Nascimento, J. C. (2021). Introduction of human-centric AI assistant to aid radiologists for multimodal breast image classification. *International Journal of Human-Computer Studies*, *150*, 102607. <https://doi.org/10.1016/j.ijhcs.2021.102607>

Celino, I., & Re Calegari, G. (2020). Submitting surveys via a conversational interface: An evaluation of user acceptance and approach effectiveness. *International Journal of Human-Computer Studies*, *139*, 102410. <https://doi.org/10.1016/j.ijhcs.2020.102410>

Cheng, X., Zhang, X., Yang, B., & Fu, Y. (2022). An investigation on trust in <span class="nocase">AI-enabled</span> collaboration: Application of AI-Driven chatbot in accommodation-based sharing economy. *Electronic Commerce Research and Applications*, *54*, 101164. <https://doi.org/10.1016/j.elerap.2022.101164>

Crompton, L. (2021). The decision-point-dilemma: Yet another problem of responsibility in human-AI interaction. *Journal of Responsible Technology*, *7–8*, 100013. <https://doi.org/10.1016/j.jrt.2021.100013>

Design Portland. (2018). Humans Have the Final Say Stories. In *Design Portland*. https://designportland.org/.

Google. (n.d.). *Our Principles Google AI*. https://ai.google/principles.

Google. (2022). *Google Presents: AI@ ‘22*.

Gratch, J., & Fast, N. J. (2022). The power to harm: AI assistants pave the way to unethical behavior. *Current Opinion in Psychology*, *47*, 101382. <https://doi.org/10.1016/j.copsyc.2022.101382>

Harvard Advanced Leadership Initiative. (2021). *Human-AI Interaction: From Artificial Intelligence to Human Intelligence Augmentation*.

IxDF. (n.d.). *What is Interaction Design?* https://www.interaction-design.org/literature/topics/interaction-design.

Jiang, Q., Zhang, Y., & Pian, W. (2022). Chatbot as an emergency exist: Mediated empathy for resilience via human-AI interaction during the COVID-19 pandemic. *Information Processing & Management*, *59*(6), 103074. <https://doi.org/10.1016/j.ipm.2022.103074>

Justin Baker. (2018). Red Routes Critical Design Paths That Make or Break Your App. In *Muzli*. https://medium.muz.li/red-routes-critical-design-paths-that-make-or-break-your-app-a642ebe0940a.

Karpus, J., Krüger, A., Verba, J. T., Bahrami, B., & Deroy, O. (2021). Algorithm exploitation: Humans are keen to exploit benevolent AI. *iScience*, *24*(6), 102679. <https://doi.org/10.1016/j.isci.2021.102679>

Kate Moran. (2016). *Designing for Young Adults (Ages 18)*. https://www.nngroup.com/articles/young-adults-ux/.

Kolko, J., & Connors, C. (2010). *Thoughts on interaction design: A collection of reflections*. Morgan Kaufmann.
<span class="csl-block">First published: Savannah, GA : Brown Bear, c2007</span>

Leite, M. L., de Loiola Costa, L. S., Cunha, V. A., Kreniski, V., de Oliveira Braga Filho, M., da Cunha, N. B., & Costa, F. F. (2021). Artificial intelligence and the future of life sciences. *Drug Discovery Today*, *26*(11), 2515–2526. <https://doi.org/10.1016/j.drudis.2021.07.002>

Li, T., Vorvoreanu, M., DeBellis, D., & Amershi, S. (2022). Assessing human-AI interaction early through factorial surveys: A study on the guidelines for human-AI interaction. *ACM Transactions on Computer-Human Interaction*.

Li, X., & Sung, Y. (2021). Anthropomorphism brings us closer: The mediating role of psychological distance in User assistant interactions. *Computers in Human Behavior*, *118*, 106680. <https://doi.org/10.1016/j.chb.2021.106680>

Liang, P., Bommasani, R., Lee, T., Tsipras, D., Soylu, D., Yasunaga, M., Zhang, Y., Narayanan, D., Wu, Y., Kumar, A., Newman, B., Yuan, B., Yan, B., Zhang, C., Cosgrove, C., Manning, C. D., Ré, C., Acosta-Navas, D., Hudson, D. A., … Koreeda, Y. (2022). *Holistic Evaluation of Language Models* (No. arXiv:2211.09110). arXiv. <https://arxiv.org/abs/2211.09110>
<span class="csl-block">Comment: Authored by the Center for Research on Foundation Models (CRFM) at the Stanford Institute for Human-Centered Artificial Intelligence (HAI). Project page: https://crfm.stanford.edu/helm/v1.0</span>

Liu, B., & Wei, L. (2021). Machine gaze in online behavioral targeting: The effects of algorithmic human likeness on social presence and social influence. *Computers in Human Behavior*, *124*, 106926. <https://doi.org/10.1016/j.chb.2021.106926>

Lorenzo, D., Lorenzo, D., & Lorenzo, D. (2015). Daisy Ginsberg Imagines A Friendlier Biological Future. In *Fast Company*. https://www.fastcompany.com/3051140/daisy-ginsberg-is-natures-most-deadly-synthetic-designer.

Lv, X., Luo, J., Liang, Y., Liu, Y., & Li, C. (2022). Is cuteness irresistible? The impact of cuteness on customers’ intentions to use AI applications. *Tourism Management*, *90*, 104472. <https://doi.org/10.1016/j.tourman.2021.104472>

Mohit Moondra. (n.d.). Navigate more sustainably and optimize for fuel savings with eco-friendly routing. In *Google Cloud Blog*. https://cloud.google.com/blog/products/maps-platform/navigate-more-sustainably-and-optimize-fuel-savings-eco-friendly-routing.

Ramchurn, S. D., Stein, S., & Jennings, N. R. (2021). Trustworthy human-AI partnerships. *iScience*, *24*(8), 102891. <https://doi.org/10.1016/j.isci.2021.102891>

Richard Yang. (2021). Interaction design is more than just user flows and clicks. In *UX Collective*. https://uxdesign.cc/interaction-design-is-more-than-just-user-flows-and-clicks-4cc37011418c.

Rogers, Y. (2022). The Four Phases of Pervasive Computing: From Vision-Inspired to Societal-Challenged. *IEEE Pervasive Comput.*, *21*(3), 9–16. <https://doi.org/10.1109/MPRV.2022.3179145>

Rooney-Varga, J., Kapmeier, F., Sterman, J., Jones, A., Putko, M., & Rath, K. (2019). The climate action simulation. *Simulation & Gaming*, *51*, 104687811989064. <https://doi.org/10.1177/1046878119890643>

Ross, L., Arrow, K., Cialdini, R., Diamond-Smith, N., Diamond, J., Dunne, J., Feldman, M., Horn, R., Kennedy, D., Murphy, C., Pirages, D., Smith, K., York, R., & Ehrlich, P. (2016). The Climate Change Challenge and Barriers to the Exercise of Foresight Intelligence. *BioScience*, *66*(5), 363–370. <https://doi.org/10.1093/biosci/biw025>

Schoonderwoerd, T. A. J., Jorritsma, W., Neerincx, M. A., & van den Bosch, K. (2021). Human-centered XAI: Developing design patterns for explanations of clinical decision support systems. *International Journal of Human-Computer Studies*, *154*, 102684. <https://doi.org/10.1016/j.ijhcs.2021.102684>

Seeber, I., Bittner, E., Briggs, R. O., de Vreede, T., de Vreede, G.-J., Elkins, A., Maier, R., Merz, A. B., Oeste-Reiß, S., Randrup, N., Schwabe, G., & Söllner, M. (2020). Machines as teammates: A research agenda on AI in team collaboration. *Information & Management*, *57*(2), 103174. <https://doi.org/10.1016/j.im.2019.103174>

Şerban, C., & Todericiu, I.-A. (2020). Alexa, what classes do I have today? The use of artificial intelligence via smart speakers in education. *Procedia Computer Science*, *176*, 2849–2857. <https://doi.org/10.1016/j.procs.2020.09.269>
<span class="csl-block">Knowledge-Based and Intelligent Information & Engineering Systems: Proceedings of the 24th International Conference KES2020</span>

Shenoi, S. (2018). Participatory design and the future of interaction design. In *Medium*. https://uxdesign.cc/participatory-design-and-the-future-of-interaction-design-81a11713bbf.

Shin, D. (2020). How do users interact with algorithm recommender systems? The interaction of users, algorithms, and performance. *Computers in Human Behavior*, *109*, 106344. <https://doi.org/10.1016/j.chb.2020.106344>

Shin, D., Zhong, B., & Biocca, F. (2020). Beyond user experience: What constitutes algorithmic experiences? *International Journal of Information Management*, *52*, 102061. <https://doi.org/10.1016/j.ijinfomgt.2019.102061>

Singer, U., Polyak, A., Hayes, T., Yin, X., An, J., Zhang, S., Hu, Q., Yang, H., Ashual, O., Gafni, O., Parikh, D., Gupta, S., & Taigman, Y. (2022). Make-<span class="nocase">A-video</span>: <span class="nocase">Text-to-video</span> generation without text-video data. *ArXiv*, *abs/2209.14792*.

Stanford Encyclopedia of Philosophy. (2021). *The Turing Test*. https://plato.stanford.edu/entries/turing-test/.

Szczuka, J. M., Strathmann, C., Szymczyk, N., Mavrina, L., & Krämer, N. C. (2022). How do children acquire knowledge about voice assistants? A longitudinal field study on children’s knowledge about how voice assistants store and process data. *International Journal of Child-Computer Interaction*, *33*, 100460. <https://doi.org/10.1016/j.ijcci.2022.100460>

Tamkin, A., Brundage, M., Clark, J., & Ganguli, D. (2021). *Understanding the capabilities, limitations, and societal impact of large language models*. arXiv. <https://doi.org/10.48550/arxiv.2102.02503>

Tang, J., LeBel, A., Jain, S., & Huth, A. G. (2022). *Semantic reconstruction of continuous language from non-invasive brain recordings* \[Preprint\]. Neuroscience. <https://doi.org/10.1101/2022.09.29.509744>

Tash Keuneman. (2022). We love to hate Clippy but what if Clippy was right? In *UX Collective*. https://uxdesign.cc/we-love-to-hate-clippy-but-what-if-clippy-was-right-472883c55f2e.

*The A-Z of AI*. (n.d.). https://atozofai.withgoogle.com/.

The International Ergonomics Association. (2019). *Human Factors/Ergonomics (HF/E)*. https://iea.cc/what-is-ergonomics/.

Tristan Greene. (2022). Confused Replika AI users are trying to bang the algorithm. In *TNW*. https://thenextweb.com/news/confused-replika-ai-users-are-standing-up-for-bots-trying-bang-the-algorithm.

Tubik Studio. (2018). UX Design Glossary: How to Use Affordances in User Interfaces. In *Medium*. https://uxplanet.org/ux-design-glossary-how-to-use-affordances-in-user-interfaces-393c8e9686e4.

Turing, A. M. (1950). I. *Mind*, *LIX*(236), 433–460. <https://doi.org/10.1093/mind/LIX.236.433>

van Wynsberghe, A. (2021). Sustainable AI: AI for sustainability and the sustainability of AI. *AI Ethics*, *1*(3), 213–218. <https://doi.org/10.1007/s43681-021-00043-6>

Veitch, E., & Andreas Alsos, O. (2022). A systematic review of human-AI interaction in autonomous ship systems. *Safety Science*, *152*, 105778. <https://doi.org/10.1016/j.ssci.2022.105778>

Weinschenk, S. (2011). *100 things every designer needs to know about people*. New Riders.

Women in AI. (n.d.). How can AI assistants help patients monitor their health? In *Spotify*. https://open.spotify.com/episode/3dL4m7ciCY0tnirZT2emzs.

Yuan, C., Zhang, C., & Wang, S. (2022). Social anxiety as a moderator in consumer willingness to accept AI assistants based on utilitarian and hedonic values. *Journal of Retailing and Consumer Services*, *65*, 102878. <https://doi.org/10.1016/j.jretconser.2021.102878>

Zafar, N., & Ahamed, J. (2022). Emerging technologies for the management of COVID19: A review. *Sustainable Operations and Computers*, *3*, 249–257. <https://doi.org/10.1016/j.susoc.2022.05.002>

Zhang, G., Chong, L., Kotovsky, K., & Cagan, J. (2023). Trust in an AI versus a Human teammate: The effects of teammate identity and performance on Human-AI cooperation. *Computers in Human Behavior*, *139*, 107536. <https://doi.org/10.1016/j.chb.2022.107536>
