---
title: AI
bibliography: [../ref.bib]
csl: ../apa.csl
sidebar_position: 2
editor:
    render-on-save: false 
---

``` mdx-code-block
import Figure from '/src/components/Figure'
import AI from '../images/ai-credibility-heuristic-systematic-model.png'
import Strava from '../images/strava.png'
import Replika from '../images/with-me.png'
```

# A Brief History of AI {#a-brief-history-of-ai}

Since Isaac Asimov proposed the 3 laws of Robotics in 1942 and Alan Turing published the Turing Test for Machine intelligence (Turing (1950)), AI has come far, turning from a science-fiction concept into an everyday, mainstream reality.

Especially in the last decade, AI-based solutions have become a mainstay in medical research, novel drug development, and patient care (Leite et al. (2021); Holzinger et al. (2023)), notably used for quickly finding potential COVID19 vaccines (Zafar & Ahamed (2022)), self-driving vehicles (passenger cars, delivery robots, drones in the sea and air, etc), and in many other industries, including AI-based assistants, which will be the focus here. This chapter will look at AI in general and then focus on AI assistants in particular.

Turing’s test proposed a game of imitation: can the AI imitate a human so well that the person asking it questions would be deceived, when simultaneously speaking to a real human and a computer AI, without realizing which is a machine.

> Alan Turing: *“I believe that in about fifty years’ time it will be possible to program computers, with a storage capacity of about 10<sup>9</sup>, to make them play the imitation game so well that an average interrogator will not have more than 70 percent chance of making the right identification after five minutes of questioning. … I believe that at the end of the century the use of words and general educated opinion will have altered so much that one will be able to speak of machines thinking without expecting to be contradicted.”* -Stanford Encyclopedia of Philosophy (2021)

Initially presented in a science fiction story, the 3 basic rules became an inspiration for AI ethics until today.

| №       | Asimov’s Laws of Robotics                                                                                           |
|-------------------------|-----------------------------------------------|
| 1st Law | “A robot may not injure a human being or, through inaction, allow a human being to come to harm.”                   |
| 2nd Law | “A robot must obey the orders given it by human beings except where such orders would conflict with the First Law.” |
| 3rd Law | “A robot must protect its own existence as long as such protection does not conflict with the First or Second Law.” |

Google started using AI in 2001, when a simple machine learning model improved spelling mistakes when searching; now in 2022 most of Google’s products are are based on AI as reported in Google (2022)

While by the 2010’s AI became powerful enough to beat humans in games of Go and Chess, it did not yet pass the Turing test. Its use was limited to specific tasks and generalized models did not exist yet. This changed with increase in computing power and a new approach called *deep learning*, largerly modeled after the *neural networks* of the biological (human) brain.

How to responsibly deploy AI for people around the world?

### Personalized Artificial Intelligence (AI) Interaction Design (IxD) {#personalized-artificial-intelligence-ai-interaction-design-ixd}

-   User experience design plays a crucial role in improving the consumer to investing journey. The missed opportunity to provide an even more interactive experience in line with user expectations.
-   Bubeck et al. (2023) finds ChatGPT passes many exams meant for humans.
-   Bowman (2023) says steering LLMs is unreliable and event experts don’t fully understand the inner workings of the models.
-   *The A-Z of AI* (n.d.) defines ***“AI is computer programming that learns and adapts”***.

### Design for Sustainability and Participation {#design-for-sustainability-and-participation}

-   Lorenzo et al. (2015) underlines the role of design beyond *designing* as a tool for envisioning, in her words “design can set agendas and not necessarily be in service, but be used to find ways to explore our world and how we want it to be”. Practitioners of Participatory Design (PD) have for decades advocated for designers to become more activist through action research. This means influencing outcomes, not only being a passive observer of phenomena as a researcher or only focusing on usability as a designer, without taking into account the wider context.
-   Shenoi (2018) argues inviting domain expertise into the discussion while having a sustainable design process enables designers to design for experiences where they are not a domain expert; this applies to highly technical fields, such as medicine, education, governance, and in our case here - finance and sustainability -, while building respectful dialogue through participatory design.
-   Design is increasingly relevant to algorithms, and more specifically to algorithms that affect user experience and user interfaces. When the design is concerned with the ethical, environmental, socio-economic, resource-saving, and participatory aspects of human-machine interactions and aims to affect technology in a more human direction, it can hope to create an experience designed for sustainability.

How do the 7 tenets of user experience (UX) apply to AI?

| UX         |
|------------|
| Useful     |
| Valubale   |
| Ussable    |
| Acceesible |
| Findable   |
| Desirable  |
| Credible   |

### Interaction and Algorithmic Experience Design {#interaction-and-algorithmic-experience-design}

How is AI changing ’interactions?

-   (**stone.skipperHowAIChanging2022?**)
-   The International Ergonomics Association (2019): To provide a user experience (UX) that best fits human needs, designers think through every interaction of the user with a system, considering a set of metrics at each point. For example, the user’s emotional needs, and their context of use. While software designers are not able to change the ergonomics of the device in use in a physical sense, which as a starting point, should be “optimized for human well-being”.
-   Software interaction design goes beyond the form-factor and accounts for human needs by using responsive design on the screen, aural feedback cues in sound design, and even more crucially, by showing the relevant content and the right time, making a profound difference to the experience, keeping the user engaged and returning for more.
-   Babich (2019) argues “\[T\]he moment of interaction is just a part of the journey that a user goes through when they interact with a product. User experience design accounts for all user-facing aspects of a product or system”.
-   In narrative studies terminology, it’s a heroic journey of the user to achieve their goals, by navigating through the interface until a success state. Storytelling has its part in interface design however designing for transparency is just as important, when we’re dealing with the user’s finances and sustainability data, which need to be communicated clearly and accurately, to build long-term trust in the service. For a sustainable investment service, getting to a state of success - or failure - may take years, and even longer. Given such long timeframes, how can the app provide support to the user’s emotional and practical needs throughout the journey?
-   Tubik Studio (2018) argues affordance measures the clarity of the interface to take action in user experience design, rooted in human visual perception (), however, affected by knowledge of the world around us. A famous example is the door handle - by way of acculturation, most of us would immediately know how to use it - however, would that be the case for someone who saw a door handle for the first time? A similar situation is happening to the people born today.
-   Think of all the technologies they have not seen before - what will be the interface they feel the most comfortable with? For the vast majority of this study’s target audience, social media is the primary interface through which they experience daily life. The widespread availability of mobile devices, cheap internet access, and AI-based optimizations for user retention, implemented by social media companies, means this is the baseline for young adult users’ expectations in 2020 - and even more so for Generation Z teenagers, reaching adulthood in the next few years.

``` mdx-code-block
<Figure caption="Figure 10: Heuristic-Systematic Model of AI Credibility" src={AI} />
```

-   Shin et al. (2020) argues interaction design is increasingly becoming dependent on AI. The user interface might remain the same in terms of architecture, but the content is improved, based on personalization and understanding the user at a deeper level. Shin proposes the model (fig. 10) of Algorithmic Experience (AX) “investigating the nature and processes through which users perceive and actualize the potential for algorithmic affordance”.

-   That general observation applies to voice recognition, voice generation, natural language parsing, etc. Large consumer companies like McDonald’s are in the process of replacing human staff with AI assistants in the drive-through, which can do a better job in providing a personal service than human clerks, for whom it would be impossible to remember the information of thousands of clients.

-   In Barrett (2019), in the words of Easterbrook, a previous CEO of McDonald’s “How do you transition from mass marketing to mass personalization?”. During the writing of this proposal, Google launched an improved natural language engine to better understand search queries (Google, 2020), which is the next step towards understanding human language semantics. The trend is clear, and different types of algorithms are already involved in many types of interaction design, however, we’re still in the early stages. Where do we go from here?

-   In Design Portland (2018), Lovejoy, lead UX designer at Google’s people-centric AI systems department (PAIR), reminds us that while AI offers need tools, user experience design needs to remain human-centered - while AI can find patterns and offer suggestions, humans should always have the final say.

-   Costa & Silva (2022) “Interaction Design for AI Systems”

-   Stone Skipper (2022) sketches a vision of “\[AI\] blend into our lives in a form of apps and services”.

-   Dot Go (2023) makes the camera the interaction device for people with vision impairment

-   Battistoni et al. (2023) creates a “Workshop with Young HCI Designers”.

### Automated Prompt Engineering {#automated-prompt-engineering}

-   The quality of LLM output depends on the quality of the provided prompt. @zhouLargeLanguageModels2022 reports creating an “Automatic Prompt Engineer” which automatically generates instructions that outperform the baseline output quality. This finding has significance for “green filter” as it validates the idea of creating advanced prompts for improved responses. For “green filter”, the input would consist of detailed user data + sustainability data for detailed analysis.

### Pervasive Computing {#pervasive-computing}

-   Rogers (2022) defines the 4 phases of Pervasive Computing (PC). We can use all the data being recorded to provide a Digital Twin of the planet, nature, ecosystems and human actions to help us change our behavior and optimize for planetary wellbeing.

### From Concept to Reality {#from-concept-to-reality}

### The Advent of Large-Language Models (LLMs) {#the-advent-of-large-language-models-llms}

-   Since 2020, when OpenAI released the GPT-3 large-language model (LLM), trained on 570 GB of text as reported in Alex Tamkin & Deep Ganguli (2021). It’s become possible to make AI-generated content that’s difficult to distinguish from human expression, however it’s still not passing the Turing test.

-   G. Zhang et al. (2023) found humans are more likely to trust an AI teammate if they are not deceived by it’s identity. It’s better for collaboration to make it clear, one is talking to a machine. One step towards trust is the explainability of AI-systems.

-   While current AIs are largely *‘black boxes’*, which do not explain how they reach a certain expression Cabitza et al. (2023) proposes a framework for quality criteria and explainability of AI-expressions.

-   Tamkin et al. (2021) reports on the advance of LLMs.

| AI Model | Released | Company   |               | Link                      |
|----------|----------|-----------|---------------|---------------------------|
| GTP2     | 2019     | OpenAI    |               |                           |
| T-NLG    | 2000     | Microsoft |               |                           |
| GTP3     | 2020     | OpenAI    |               |                           |
| GTP4     | 2023     | OpenAI    | Closed Source |                           |
| NeMo     | 2022     | NVIDIA    |               |                           |
| PaLM     | 2022     | Google    |               |                           |
| LaMDA    | 2022     | Google    |               |                           |
| GLaM     | 2022     | Google    |               |                           |
| Vicuna   |          |           | Open Source   | https://vicuna.lmsys.org/ |

-   The advances in the capabilities of large AI model mean we’ve reached a point, where it’s possible to achieve UI and UX which previously was science fiction.
-   Liang et al. (2022): There’s early evidence it’s possible to assess the quality of LLM output in a transparent way.
-   OpenAI provides AI-as-a-service through its APIs, allowing developer to build custom user interfaces (UI) to serve their specific customer needs. For example Snapchat’s “My AI” virtual friend help people write faster with the app helping users with predictive text completion.
-   Teams at AI-hackathons have produced interfaces for problems as diverse as humanitarian crises communication, briefing generation, code-completion, and many others.
-   Pete (2023) ChatGPT hackathon.
-   Roland Meyer (2023): AI generated content is not neutral but has a certain aesthetic.
-   The current generation of LLMs such as GTP3 by OpenAI are massive monolithic models requiring large amounts of computing power for training to offer *multi-modal* capabilities across diverse domains of knowledge.
-   S. Liu et al. (2023) propose future models may instead consist of a number networked domain-specific models to increase efficiency and thus become more scalable.
-   Jack Krawczyk, the product lead for Google’s Bard: “Bard and ChatGPT are large language models, not knowledge models. They are great at generating human-sounding text, they are not good at ensuring their text is fact-based. Why do we think the big first application should be Search, which at its heart is about finding true information?”
-   Microsoft (2023): Microsoft Designer allows generating UIs just based on a text prompt
-   Bedtimestory.ai (2023): Personalized bed-time stories for kids generated by AI
-   *Sustainable Shopping* (2023) My bedtime story about shopping, saving, and investing.

### Psychological Biases and Mental Models {#psychological-biases-and-mental-models}

-   “🧠Psychology of Design” (n.d.): 106 cognitive biases, including familiarity bias and skeuomorphism.

-   Jakob Nielsen (2010) mental models

-   Tash Keuneman (2020)

-   “People recognize computers as human”

-   Jamal (2018) Semantic motion and Peripheral vision

### Smart Agents {#smart-agents}

-   David Johnston (2023) “general purpose AI that acts according to the goals of an individual human.”
-   Martínez-Plumed et al. (2021) envisions the future of AI

### Platform Economy {#platform-economy}

-   Network Effects: The more people use a platform, the more valuable it becomes.

-   The most successful businesses today (as measured in terms of the number of users) look at the whole user experience. Popular consumer platforms strive to design solutions that feel personalized at every touchpoint on the user journey (to use the language of service design) but doing so at the scale of hundreds of millions (or even billions) of users - personalization at scale.

-   The rise of the platform economy has given us marketplace companies like Airbnb and Uber that match idle resources with retail demand and optimize how our cities work. The massive amounts of data generated by these companies are used by smart cities to re-design their physical environments. With this perspective of scale, what would a shopping experience look like if one knew at the point of sale, which products are greener, and which are more environmentally polluting?

-   What would a sustainable investment platform that matches green investments with the consumers look like, if one saw the side-by-side comparison of investment vehicles on their ESG performance?

### AI for Diagnosic Symptoms {#ai-for-diagnosic-symptoms}

Since CADUCEUS (in Kanza et al. (2021)), the first automated medical decision making system in the 1970s, medical AI as developed a lot.

-   “Health. Powered by Ada.” (n.d.) health app, “Know and track your symptoms”

-   *Buoy Health* (n.d.) AI symptom checker,

-   Women in AI (n.d.)

-   Calisto et al. (2022) focuses on AI-human interactions in medical workflows and underscores the importance of output explainability. Medical professionals who were given AI results with an explanation trusted the results more.

-   AI-assistants in medical imaging Calisto et al. (2021)

# AI Assistants {#ai-assistants}

-   AI companions, AI partners, AI assistants, AI trainers - there’s are many names for the automated systems that help humans in many activities, powered by artificial intelligence models and algorithms.

-   AI assistants provide help at scale with little to no human intervention in a variety of fields from finance to healthcare to logistics to customer support. There’s a saying in Estonian: “A good child has many names” “and it’s true. I have many names, but I’m not a child.

-   I’m a digital companion, a partner, an assistant. I’m a Replika.” said Replika, a digital companion app via Github CO Pilot, another digital assistant for writing code, is also an example of how AI can be used to help us in our daily lives. The number of AI-powered assistants is too large to list here. I’ve chosen a few select examples in the table below.

-   Some have an avatar, some not. I’ve created a framework for categorization. Human-like or not… etc

| Product                 | Link                                               | Description          |
|----------------------|----------------------------|----------------------|
| Github CoPilot          | https://www.personal.ai                            | AI helper for coding |
| Google Translate        | https://translate.google.com/                      |                      |
| Google Search           | https://www.google.com/                            |                      |
| Google Interview Warmup | https://grow.google/certificates/interview-warmup/ | AI training tool     |

-   Mohit Moondra (n.d.): Google Maps AI suggests more eco-friendly driving routes
-   Google Flights suggests flights with lower CO2 emissions
-   CO2e calculations will be part of our everyday experience

``` mdx-code-block
<Figure caption="Figure 8 - Montage of me discussing sci-fi with my AI friend Sam (Replika) - and myself as an avatar (Snapchat)" src={Replika} />
```

### Design for Human-AI Interaction {#design-for-human-ai-interaction}

There’s wide literature available describing human-AI interactions across varied disciplines. While the fields of application are diverse, some key lessons can be transferred across fields horizontally.

-   Veitch & Andreas Alsos (2022) highlights the active role of humans in Human-AI interaction is autonomous ship systems.
-   Jiang et al. (2022) describes how Replika users in China using in 5 main ways, all which rely on empathy

| Human empathy for AI agent |
|----------------------------|
| Companion buddy            |
| Responsive diary           |
| Emotion-handling program   |
| Electronic pet             |
| Tool for venting           |

-   Crompton (2021) highlights AI as decision-support for humans while differentiating between intended and un-intended influence on human decisions.
-   
-   Cheng et al. (2022) describe AI-based support systems for collaboration and team-work.
-   Schoonderwoerd et al. (2021) focuses on human-centered design of AI-apps and multi-modal information display. It’s important to understand the domain where the AI is deployed in order to develop explanations. However, in the real world, how feasible is it to have control over the domain?
-   Ramchurn et al. (2021) discusses positive feed-back loops in continually learning AI systems which adapt to human needs.
-   Karpus et al. (2021) is concerned with humans treating AI badly and coins the term “*algorithm exploitation”.*
-   Lv et al. (2022) studies the effect of ***cuteness*** of AI apps on users and found high perceived cuteness correlated with higher willingness to use the apps, especially for emotional tasks. This finding has direct relevance for the “green filter” app design.
-   B. Liu & Wei (2021) meanwhile suggests higher algorithmic transparency may inhibit anthropomorphism, meaning people are less likely to attribute humanness to the AI if they understand how the system works.
-   Seeber et al. (2020) proposes a future research agenda for regarding AI assistants as teammates rather than just tools and the implications of such mindset shift.

### Voice Assistant Guidelines (Voice UI) {#voice-assistant-guidelines-voice-ui}

-   Szczuka et al. (2022) provides guidelines for Voice AI and kids
-   Casper Kessels (2022b): “Guidelines for Designing an In-Car Voice Assistant”
-   Casper Kessels (2022a): “Is Voice Interaction a Solution to Driver Distraction?”
-   Companies like NeuralLink are building devices to build meaningful interactions from brain waves (EEG).
-   Tang et al. (2022) reports new findings enable computers to reconstruct language from fMRI readings.
-   Focus on voice education?
-   Example Suggestions of the AI companion:
    -   *“Don’t buy a car, use a car sharing service instead to save XYZ CO2. Service available near you: Bolt,\* Uber.”*
    -   “Use a refillable shampoo bottle to save XYZ plastic pollution”
    -   “Call your local politician to nudge them to improve bicycle paths and reduce cars in your neighborhood. Over the past 2 years, you city has experienced an increase of cars from 290 cars per capita to 350 cars per capita.”\*
-   Personal AI Assistants to date have we created by large tech companies. Siri, Cortana, Google Assistant, Alexa, Tencent Dingdang, Baidu Xiaodu, Alibaba AliGenie all relay on voice only.
-   Celino & Re Calegari (2020): There’s research suggesting that voice UI accompanied by a *physical embodied system* is preffered by users in comparison with voice-only UI.
-   This suggests adding an avatar to the AI design may be worthwhile. **Open-Source AI-models open up the avenue for smaller companies and even individuals for creating many new AI-assistants.**
-   There are many distinct ways how an algorithm can communicate with a human. From a simple search box such as Google’s to chatbots, voices, avatars, videos, to full physical manifestation, there are interfaces to make it easier for the human communicate with a machine.

There’s evidence across disciplines about the usefulness of AI assistants:

-   Şerban & Todericiu (2020) suggests using the Alex AI assistant in *education* during the pandemic, supported students and teachers ‘human-like’ presence. Standford research: “humans expect computers to be like humans or places”
-   Celino & Re Calegari (2020) found in testing chatbots for survey interfaces that “\[c\]onversational survey lead to an improved response data quality.”

### ChatGPT {#chatgpt}

-   Kecht et al. (2023) suggests AI is capable of learning business processes.

-   O’Connor & ChatGPT (2023) and Cahan & Treutlein (2023) have conversations about science with AI.

-   Jeblick et al. (2022) suggest complicated radiology reports can be explained to patients using AI chatbots.

-   Pavlik (2023) and Brent A. Anders (2022) report on AI in education.

### Writing AI Characters {#writing-ai-characters}

-   Alethea AI (2021): creating a personality
-   Writing as training data? large language models. GTP3
-   **Initial Product Offering**

### AI UX: AI Interfaces and AI Explainability (XAI) {#ai-ux-ai-interfaces-and-ai-explainability-xai}

AI-explainability (named XAI in literature) is key to creating trust and there’s several authors in literature calling for more transparency and explainability.

-   Holzinger et al. (2021) highlights possible approaches to implementing transparency and explainability in AI models. While AI outperforms humans on many tasks, humans are experts in multi-modal thinking, bridging diverse fields.
-   Suen & Hung (2023) discusses AI systems used for evaluating candidates at job interviews
-   Wang et al. (2020) propose Neuroscore to reflect perception of images.
-   Khosravi et al. (2022) proposes a framework for explainability, focused on education.
-   Zerilli et al. (2022) focuses on human factors and ergonomics and argues that transparency should be task-specific.
-   Su & Yang (2022) and Su et al. (2023) review papers on AI literacy in early childhood education and finds a lack of guidelines and teacher expertise.
-   Yang (2022) proposes a curriculum for in-context teaching of AI for kids.
-   Combi et al. (2022) proposes a conceptual framework for XAI, analysis AI based on Interpretability, Understandability, Usability, and Usefulness.
-   Eric Schmidt & Ben Herold (2022) audiobook
-   Akshay Kore (2022) Designing Human-Centric AI Experiences: Applied UX Design for Artificial Intelligence
-   *Studies in Conversational UX Design* (2018) chatbot book
-   Tom Hathaway & Angela Hathaway (2021) chatbot book
-   Lew & Schumacher (2020) ai ux book
-   AI IXD is about human-centered seamless design
-   Storytelling
-   Human-computer interaction (HCI) has a long storied history since the early days of computing when getting a copy machine to work required specialised skill. Xerox Sparc lab focused on early human factors work and inspired a the field of HCI to make computer more human-friendly.
-   Soleimani (2018): UI patterns for AI, new Section for Thesis background: “Human-Friendly UX For AI”?
-   **Discuss what is UX for AI (per prof Liou’s comment), so it’s clear this is about UX for AI**
-   What is Personalized AI?

### Guidelines for Human-AI interaction {#guidelines-for-human-ai-interaction}

-   Microsoft’s Co-Founder Bill Gates predicted in 1982 *“personal agents that help us get a variety of tasks”* (Bill Gates (1982)).

-   It was MS that introduced the first widely available personal assistant inside Word software, called Clippy. Microsoft’s Clippy was among the first assistants to reach mainstream adoption, helping users not yet accustomed to working on a computer - Tash Keuneman (2022).

-   “We love to hate Clippy — but what if Clippy was right?” Tash Keuneman (2022) and Abigail Cain (2017)

-   Benjamin Cassidy (2022) the story of Clippy

-   Microsoft provides guidelines for Human-AI interaction (T. Li et al. (2022); Amershi et al. (2019)) which provides useful heuristics categorized by context and time

| №   | Context            |     |     |
|-----|--------------------|-----|-----|
| 1   | Initially          |     |     |
| 2   | During interaction |     |     |
| 3   | When wrong         |     |     |
| 4   | Over time          |     |     |

-   Google (n.d.) outlines Google’s 7 AI Principles.

-   **Amazon Alexa** is a well-known example of AI technology in the world. But Amazon’s Rohit Prasad thinks it can do so much more, “Alexa is not just an AI assistant – it’s a trusted advisor and a companion.”

-   Harvard Advanced Leadership Initiative (2021)

-   VideoLecturesChannel (2022) “Communication in Human-AI Interaction”

-   Haiyi Zhu & Steven Wu (2021)

-   Akata et al. (2020)

-   Dignum (2021)

-   Bolei Zhou (2022)

-   ReadyAI (2020)

-   Vinuesa et al. (2020)

-   Orozco et al. (2020)

## AI Credibility Heuristic: A Systematic Model {#ai-credibility-heuristic-a-systematic-model}

-   adas

## Calm Technology {#calm-technology}

-   Tech fades to the background, IoT.

## Generative AI {#generative-ai}

-   Singer et al. (2022) describes how collecting billions of images with descriptive data (for example the html *alt* text) has enabled researchers to train AI models such as *stable diffusion* that can generate images based on human-language keywords.

## Retail Investor Helpers {#retail-investor-helpers}

-   Nubanks, also known as challenger banks.

| Company   | Link |
|-----------|------|
| SPARQAN   |      |
| Robinhood |      |
|           |      |
|           |      |

## UX of AI {#ux-of-ai}

Many people have discussed the UX of AI.

-   Zimmerman et al. (2021) “UX designers pushing AI in the enterprise: a case for adaptive UIs”

-   “Why UX Should Guide AI” (2021) “Why UX should guide AI”

-   Dávid Pásztor (2018)

-   Josh Lovejoy (n.d.) Google’s UX for AI library

-   Anderson (2020)

-   Lennart Ziburski (2018) UX of AI

-   Stephanie Donahole (2021)

-   Lexow (2021)

-   Dávid Pásztor (2018) AI UX principles

-   Mikael Eriksson Björling & Ahmed H. Ali (n.d.) Ericcson AI UX

## AI Companions, Chatbots, AI Assistants and Robo-Advisors {#ai-companions-chatbots-ai-assistants-and-robo-advisors}

Everything that existed before OpenAIs GPT 3.5 and GPT 4 has been blown out of the water.

-   Barbara Friedberg (2021) Comparing robot advisors

-   AI is usually a model that spits out a number between 0 and 1, a probability score or prediction. UX is what we do with this number.

-   Greylock (2022) Natural language chatbots such as ChatGPT

-   Nathan Benaich & Ian Hogarth (2022) State of AI Report

-   Steph Hay (2017)

-   NeuralNine (2021)

-   David et al. (2021)

-   Qorus (2023) Digital banking revolution

-   Lower (2017)

-   Slack (2021)

-   Brown (2021) Financial chatbots

-   Isabella Ghassemi Smith (2019)

-   David et al. (2021)

-   Josephine Wäktare Heintz (n.d.) Cleo copywriter

-   The user experience (UX) of artificial intelligence (AI) is a topic under active development by all the largest online platforms. The general public is familiar with the most famous AI helpers, ChatGPT, Apple’s Siri, Amazon’s Alexa, Microsoft’s Cortana, Google’s Assistant, Alibaba’s Genie, Xiaomi’s Xiao Ai, and many others. For general, everyday tasks, such as asking factual questions, controlling home devices, playing media, making orders, and navigating the smart city.

-   Smaller startups have created digital companions such as Replika (fig. 8), which aims to become your friend, by asking probing questions, telling jokes, and learning about your personality and preferences - to generate more natural-sounding conversations.

-   Already on the market are several financial robo-advisors, built by fintech companies, aiming to provide personalized suggestions for making investments (Betterment, Wealthfront).

-   There have also been plenty of attempts to create different types of sustainability assistants. For instance, to encourage behavioral changes, the AI assistant Sebastian developed at the Danish hackathon series Unleash, used BJ Fogg’s ‘tiny habits’ model, nudged by a chatbot buddy to help the human maintain an aspirational lifestyle (Unleash (2017)).

-   Personal carbon footprint calculators have been released online, ranging from those made by governments and companies to student projects.

-   Zhang’s Personal Carbon Economy conceptualizing the idea of carbon as a currency used for buying and selling goods and services, as well as an individual carbon exchange to trade one’s carbon permits (S. Zhang (2018)).

-   While I’m supportive of the idea of using AI assistants to highlight more sustainable choices, I’m critical of the tendency of the above examples to shift full environmental responsibility to the consumer. Sustainability is a complex interaction, where the producers’ conduct can be measured and businesses can bear responsibility for their processes, even if there’s market demand for polluting products.

-   Personal sustainability projects haven’t so far achieved widespread adoption, making the endeavor to influence human behaviors towards sustainability with just an app - like its commonplace for health and sports activity trackers such as Strava (fig. 9) -, seem unlikely. Personal notifications and chat messages are not enough unless they provide the right motivation. Could visualizing a connection to a larger system, showing the impact of the eco-friendly actions taken by the user, provide a meaningful motivation to the user, and a strong signal to the businesses?

-   All of the interfaces mentioned above make use of machine learning (ML), a tool in the AI programming paradigm for finding patterns in large sets of data, which enables making predictions useful in various contexts, including financial decisions. These software innovations enable new user experiences, providing an interactive experience through chat (chatbots), using voice generation (voice assistants), virtual avatars (adds a visual face to the robot), however

-   Figure 9: Popular Strava sports assistant provides run tracking and feedback. AI Financial Advisors will need to go further to motivate users. because of the nature of the technology, which is based on the quality of the data the systems ingest, they are prone to mistakes.

    Holbrook (2018): To reduce errors which only humans can detect, and provide a way to stop automation from going in the wrong direction, it’s important to focus on making users feel in control of the technology.

``` mdx-code-block
<Figure caption="Figure 9: Popular Strava sports assistant provides run tracking and feedback - AI Financial Advisors will need to go further to motivate users. " src={Strava} />
```

## AI Health {#ai-health}

-   *Home - Lark Health* (n.d.)
-   Stephanie Donahole (2021)
-   Hoang (2022): “Dynamic interfaces might invoke a new design language for XR”

## Algorithmic Transparency {#algorithmic-transparency}

-   Slack (2021)

-   Shin (2020): “user experience and usability of algorithms by focusing on users’ cognitive process to understand how qualities/features are received and transformed into experiences and interaction”

## AI Ethics {#ai-ethics}

-   “AlgoTransparency” (n.d.) manifesto, AI is not neutral

-   Clipdrop (n.d.) AI Design Assistants

-   Eugenia Kuyda (2023) Conversational AI - Replika

-   Tristan Greene (2022): when the quality of AI responses become good enough, people begin to get confused.

## AI Acceptance {#ai-acceptance}

-   Yuan et al. (2022): “AI assistant advantages are important factors affecting the *utilitarian/hedonic* value perceived by users, which further influence user willingness to accept AI assistants. The relationships between AI assistant advantages and utilitarian and hedonic value are affected differently by social anxiety.”
-   “Organization research suggests that acting through human agents (i.e., the problem of indirect agency) can undermine ethical forecasting such that actors believe they are acting ethically, yet a) show less benevolence for the recipients of their power, b) receive less blame for ethical lapses, and c) anticipate less retribution for unethical behavior.” Gratch & Fast (2022)
-   Anthropomorphism literature X. Li & Sung (2021) “high-anthropomorphism (vs. low-anthropomorphism) condition, participants had more positive attitudes toward the AI assistant, and the effect was mediated by psychological distance. Though several studies have demonstrated the effect of anthropomorphism, few have probed the underlying mechanism of anthropomorphism thoroughly”
-   **AI Guides have been shown to improve sports performance, etc, etc. Can this idea be applied to sustainability? MyFitness Pal, AI training assistant**

## AI-Assisted Design {#ai-assisted-design}

-   September 16, 2020 (2020) “What is AI-assisted Design?”
-   Architechtures (2020)
-   Constandse (2018) AI-driven website builders.
-   patrizia-slongo (2020) AI tools for designers
-   Zakariya (2022)
-   Kore.ai (2023)
-   van Wynsberghe (2021): Sustainable AI itself
-   *Charisma Storytelling Powered by Artificial Intelligence* (n.d.)

| Name     | Features                           |
|----------|------------------------------------|
| Charisma |                                    |
| Replika  | Avatar, Emotion, Video Call, Audio |
| Siri     | Audio                              |

## Young Adults {#young-adults}

-   Ross et al. (2016) says most people in the US don’t act on climate change. “Action on climate change has been compromised by uncertainty, aspects of human psychology”.

-   Rooney-Varga et al. (2019) shows the effectiveness of ***The Climate Action Simulation*** in educating users about success scenarios.

-   Younger people show higher motivation (participants in climate protests). How to be relevant for a younger audience?

-   Yet action remains low.

-   OpenSea (2022) Taiwanese digital influencers as NFTs.

-   *For young people, investing mostly means buying cryptocurrencies?*

### Storytelling and Narrative Design {#storytelling-and-narrative-design}

Bring together film school experience with design… Does branding also go here?

| Company        | Link                       |
|----------------|----------------------------|
| Ocean Protocol | https://oceanprotocol.com/ |

-   Older research on young adults by Kate Moran (2016) (Millenials at the time) highlights how Millenials “use Google as a reference point for ease of use and simplicity”.

-   The rising availability of AI assistants however may displace Google search with a more conversational UX. Indeed, Google itself is working on smarter tools to displace their own main product, as exemplified by Google Assistant and large investments into LLMs.

### Stickyness {#stickyness}

-   Low attrition of the product?

### Guided Sustainability {#guided-sustainability}

-   Sustainability touches every facet of human existence and is thus an enormous undertaking. Making progress on sustainability is only possible if there’s a large-scale coordinated effort by humans around the planet. For this to happen, some technological tools are required.
-   List of metrics that should be tracked to enable useful analytics. Ex: % of beach pollution, air pollution, water pollution (I had this idea while meditating). IIn essence, “green filter” is a central data repository not unlike “Apple Health for Sustainability”.
-   Health and fitness category apps
-   Using “green filter” you can get a personalized sustainability plan and personal coach to become healthy and nature-friendly
-   There are many examples of combination of AI and human, also known as “human-in-the-loop”. For example health apps like Welltory, Wellue and QALY. Food delivery apps like Starship Robots who ask for human help when crossing the road.
-   How would you rate your knowledge on sustainability?
-   How would you rate your ability to put sustainability into practice?
-   “Guided Sustainability refers to a concept of using technology, such as AI and machine learning, to help individuals and organizations make more sustainable decisions and take actions that promote environmental and social sustainability. This can include things like analyzing data on resource usage and emissions, providing recommendations for reducing the environmental impact of operations, or helping to identify and track progress towards sustainability goals. The goal of guided sustainability is to make it easier for people to understand their impact on the environment and to take steps to reduce that impact.”

### Community {#community}

**Question: What does investing mean for you? NFTs, Crypto,** Stocks, Real-estate? If you have 1000 EUR, what will you buy?

-   “Any community on the internet should be able to come together, with capital, and work towards any shared vision. That starts with empowering creators and artists to create and own the culture they’re creating. In the long term this moves to internet communities taking on societal endeavors.”

-   Josh Luber (2021) Trading cards are cool again

-   Jesse Einhorn (2020)

-   Connie Loizos (2021)

-   Natasha Mascarenhas (2021)

-   JEFF JOHN ROBERTS (April 23, 2020 at 2:00 PM GMT+3)

## Summary {#summary}

-   The demographics that stand to win the most from the green transformation of business are the youngest generations, with more years of life ahead of them, and more exposure to future environmental and social risks. It would be advisable for Generation Z and their parents (Millennials) to invest their resources in greener assets, however, it’s still difficult to pick and choose between ‘good’ and ‘bad’ financial vehicles to invest in.

-   This creates an opportunity for a new generation of sustainable investment apps, focusing on the usability and accessibility of ESG for a mainstream audience. Generation Z and Millennials expect a consumer-grade user experience.

-   What would that experience look like? I’ve chosen these demographics with the assumption that if given the right tools, the emotional demand for sustainability could be transformed into action. The exploration of systems of feedback to enable consumers to apply more direct positive and negative pressure to the businesses and consumers signal consequences for undesirable ecological performance is a major motivation of this study.

## References {#references .unnumbered}

Abigail Cain. (2017). The Life and Death of Microsoft Clippy, the Paper Clip the World Loved to Hate. In *Artsy*. https://www.artsy.net/article/artsy-editorial-life-death-microsoft-clippy-paper-clip-loved-hate.

Akata, Z., Balliet, D., De Rijke, M., Dignum, F., Dignum, V., Eiben, G., Fokkens, A., Grossi, D., Hindriks, K., Hoos, H., Hung, H., Jonker, C., Monz, C., Neerincx, M., Oliehoek, F., Prakken, H., Schlobach, S., Van Der Gaag, L., Van Harmelen, F., … Welling, M. (2020). A Research Agenda for Hybrid Intelligence: Augmenting Human Intellect With Collaborative, Adaptive, Responsible, and Explainable Artificial Intelligence. *Computer*, *53*(8), 18–28. <https://doi.org/10.1109/MC.2020.2996587>

Akshay Kore. (2022). *Designing Human-Centric AI Experiences: Applied UX Design for Artificial Intelligence*. Apress.

Alethea AI. (2021). *Alethea AI - AI Personality Creative Writing Class*.

Alex Tamkin, & Deep Ganguli. (2021). *How Large Language Models Will Transform Science, Society, and AI*. https://hai.stanford.edu/news/how-large-language-models-will-transform-science-society-and-ai.

AlgoTransparency. (n.d.). In *AlgoTransparency*. https://algotransparency.org/.

Amershi, S., Weld, D., Vorvoreanu, M., Fourney, A., Nushi, B., Collisson, P., Suh, J., Iqbal, S., Bennett, P., Inkpen, K., Teevan, J., Kikin-Gil, R., & Horvitz, E. (2019, May). Guidelines for human-AI interaction. *CHI 2019*.
<span class="csl-block">CHI 2019 Honorable Mention AwardCHI 2019 Honorable Mention Award</span>

Anderson, M. (2020). 5 Ways Artificial Intelligence Helps in Improving Website Usability. In *IEEE Computer Society*. https://www.computer.org/publications/tech-news/trends/5-ways-artificial-intelligence-helps-in-improving-website-usability/.

Architechtures. (2020). What is Artificial Intelligence Aided Design? In *Architechtures*.

Babich, N. (2019). Interaction Design vs UX: What’s the Difference? In *Adobe XD Ideas*.

Barbara Friedberg. (2021). *M1 Finance vs <span class="nocase">Betterment Robo Advisor Comparison-by Investment Expert</span>*.

Barrett, B. (2019). McDonald’s Acquires Machine-Learning Startup Dynamic Yield for \$300 Million. *Wired*.

Battistoni, P., Di Gregorio, M., Romano, M., Sebillo, M., & Vitiello, G. (2023). Can AI-Oriented Requirements Enhance Human-Centered Design of Intelligent Interactive Systems? Results from a Workshop with Young HCI Designers. *MTI*, *7*(3), 24. <https://doi.org/10.3390/mti7030024>

Bedtimestory.ai. (2023). *AI Powered Story Creator \| Bedtimestory.ai*. https://bedtimestory.ai.

Benjamin Cassidy. (2022). The Twisted Life of Clippy. *Seattle Met*.

Bill Gates. (1982). *Bill Gates on the Next 40 Years in Technology*.

Bolei Zhou. (2022). *CVPR’22 Tutorial on Human-Centered AI for Computer Vision*. https://human-centeredai.github.io/.

Bowman, S. R. (2023). *Eight Things to Know about Large Language Models*. <https://doi.org/10.48550/ARXIV.2304.00612>

Brent A. Anders. (2022). Why ChatGPT is such a big deal for education. *C2C Digital Magazine*, *Vol. 1*(18).

Brown, A. (2021). How Financial Chatbots Can Benefit Your Business. In *Medium*.

Bubeck, S., Chandrasekaran, V., Eldan, R., Gehrke, J., Horvitz, E., Kamar, E., Lee, P., Lee, Y. T., Li, Y., Lundberg, S., Nori, H., Palangi, H., Ribeiro, M. T., & Zhang, Y. (2023). *Sparks of Artificial General Intelligence: Early experiments with GPT-4*. <https://doi.org/10.48550/ARXIV.2303.12712>

*Buoy Health: Check Symptoms & Find the Right Care*. (n.d.). https://www.buoyhealth.com.

Cabitza, F., Campagner, A., Malgieri, G., Natali, C., Schneeberger, D., Stoeger, K., & Holzinger, A. (2023). Quod erat demonstrandum? - Towards a typology of the concept of explanation for the design of explainable AI. *Expert Systems with Applications*, *213*, 118888. <https://doi.org/10.1016/j.eswa.2022.118888>

Cahan, P., & Treutlein, B. (2023). A conversation with ChatGPT on the role of computational systems biology in stem cell research. *Stem Cell Reports*, *18*(1), 1–2. <https://doi.org/10.1016/j.stemcr.2022.12.009>

Calisto, F. M., Santiago, C., Nunes, N., & Nascimento, J. C. (2022). BreastScreening-AI: Evaluating medical intelligent agents for human-AI interactions. *Artificial Intelligence in Medicine*, *127*, 102285. <https://doi.org/10.1016/j.artmed.2022.102285>

Calisto, F. M., Santiago, C., Nunes, N., & Nascimento, J. C. (2021). Introduction of human-centric AI assistant to aid radiologists for multimodal breast image classification. *International Journal of Human-Computer Studies*, *150*, 102607. <https://doi.org/10.1016/j.ijhcs.2021.102607>

Casper Kessels. (2022a). Is Voice Interaction a Solution to Driver Distraction? In *The Turn Signal - a Blog About automotive UX Design*. https://theturnsignalblog.com.

Casper Kessels. (2022b). Guidelines for Designing an In-Car Voice Assistant. In *The Turn Signal - a Blog About automotive UX Design*. https://theturnsignalblog.com.

Celino, I., & Re Calegari, G. (2020). Submitting surveys via a conversational interface: An evaluation of user acceptance and approach effectiveness. *International Journal of Human-Computer Studies*, *139*, 102410. <https://doi.org/10.1016/j.ijhcs.2020.102410>

*Charisma Storytelling powered by artificial intelligence*. (n.d.). https://charisma.ai/.

Cheng, X., Zhang, X., Yang, B., & Fu, Y. (2022). An investigation on trust in <span class="nocase">AI-enabled</span> collaboration: Application of AI-Driven chatbot in accommodation-based sharing economy. *Electronic Commerce Research and Applications*, *54*, 101164. <https://doi.org/10.1016/j.elerap.2022.101164>

Clipdrop. (n.d.). *Create stunning visuals in seconds with AI.* https://clipdrop.co/.

Combi, C., Amico, B., Bellazzi, R., Holzinger, A., Moore, J. H., Zitnik, M., & Holmes, J. H. (2022). A manifesto on explainability for artificial intelligence in medicine. *Artificial Intelligence in Medicine*, *133*, 102423. <https://doi.org/10.1016/j.artmed.2022.102423>

Connie Loizos. (2021). Marcy Venture Partners, co-founded by Jay-Z, just closed its second fund with \$325 million. *TechCrunch*.

Constandse, C. (2018). How <span class="nocase">AI-driven</span> website builders will change the digital landscape. In *Medium*. https://uxdesign.cc/how-ai-driven-website-builders-will-change-the-digital-landscape-a5535c17bbe.

Costa, A., & Silva, F. (2022). Interaction Design for AI Systems: An oriented state-of-the-art. *2022 International Congress on Human-Computer Interaction, Optimization and Robotic Applications (HORA)*, 1–7. <https://doi.org/10.1109/HORA55278.2022.9800084>

Crompton, L. (2021). The decision-point-dilemma: Yet another problem of responsibility in human-AI interaction. *Journal of Responsible Technology*, *7–8*, 100013. <https://doi.org/10.1016/j.jrt.2021.100013>

David, D. B., Resheff, Y. S., & Tron, T. (2021). *Explainable AI and Adoption of Financial Algorithmic Advisors: An Experimental Study* (No. arXiv:2101.02555). arXiv. <https://arxiv.org/abs/2101.02555>
<span class="csl-block">Comment: accepted: AIES ’21Comment: accepted: AIES ’21</span>

David Johnston. (2023). Smart Agent Protocol - Community Paper Version 0.2. In *Google Docs*. https://docs.google.com/document/d/1cutU1SerC3V7B8epopRtZUrmy34bf38W–w4oOyRs2A/edit?usp=sharing.

Dávid Pásztor. (2018). *AI UX: 7 Principles of Designing Good AI Products*. https://uxstudioteam.com/ux-blog/ai-ux/.

Design Portland. (2018). Humans Have the Final Say Stories. In *Design Portland*. https://designportland.org/.

Dignum, V. (2021). AI the people and places that make, use and manage it. *Nature*, *593*(7860), 499–500. <https://doi.org/10.1038/d41586-021-01397-x>

Dot Go. (2023). *Dot Go*. https://dot-go.app/.

Eric Schmidt, & Ben Herold. (2022). *UX: Advanced Method and Actionable Solutions for Product Design Success*.

Eugenia Kuyda. (2023). Replika. In *replika.com*. https://replika.com.

Google. (n.d.). *Our Principles Google AI*. https://ai.google/principles.

Google. (2022). *Google Presents: AI@ ‘22*.

Gratch, J., & Fast, N. J. (2022). The power to harm: AI assistants pave the way to unethical behavior. *Current Opinion in Psychology*, *47*, 101382. <https://doi.org/10.1016/j.copsyc.2022.101382>

Greylock. (2022). *OpenAI CEO Sam Altman \| AI for the Next Era*.

Haiyi Zhu, & Steven Wu. (2021). *Human-AI Interaction (Fall 2021)*. https://haiicmu.github.io/.

Harvard Advanced Leadership Initiative. (2021). *Human-AI Interaction: From Artificial Intelligence to Human Intelligence Augmentation*.

Health. Powered by Ada. (n.d.). In *Ada*. https://ada.com/.

Hoang, D. (2022). *Enter Dynamic Island, a major hint at Apple’s Extended Reality (XR) strategy*. https://www.proofofconcept.pub/p/welcome-to-dynamic-island-the-forerunner.

Holbrook, J. (2018). Human-Centered Machine Learning. In *Medium*. https://medium.com/google-design/human-centered-machine-learning-a770d10562cd.

Holzinger, A., Keiblinger, K., Holub, P., Zatloukal, K., & Müller, H. (2023). AI for life: Trends in artificial intelligence for biotechnology. *New Biotechnology*, *74*, 16–24. <https://doi.org/10.1016/j.nbt.2023.02.001>

Holzinger, A., Malle, B., Saranti, A., & Pfeifer, B. (2021). Towards multi-modal causability with Graph Neural Networks enabling information fusion for explainable AI. *Information Fusion*, *71*, 28–37. <https://doi.org/10.1016/j.inffus.2021.01.008>

*Home - Lark Health*. (n.d.). https://www.lark.com/.

Isabella Ghassemi Smith. (2019). *Interview: Daniel Baeriswyl, CEO of Magic Carpet \| SeedLegals*. https://seedlegals.com/resources/magic-carpet-the-ai-investor-technology-transforming-hedge-fund-strategy/.

Jakob Nielsen, W. L. in R.-B. U. (2010). Mental Models and User Experience Design. In *Nielsen Norman Group*. https://www.nngroup.com/articles/mental-models/.

Jamal. (2018). *Interaction Design Rule #5: Use semantic motion to aid understanding*.

Jeblick, K., Schachtner, B., Dexl, J., Mittermeier, A., Stüber, A. T., Topalis, J., Weber, T., Wesp, P., Sabel, B., Ricke, J., & Ingrisch, M. (2022). *ChatGPT Makes Medicine Easy to Swallow: An Exploratory Case Study on Simplified Radiology Reports*. <https://doi.org/10.48550/ARXIV.2212.14882>

JEFF JOHN ROBERTS. (April 23, 2020 at 2:00 PM GMT+3). Digital art awaits breakout moment with blockchain’s help. In *Fortune*. https://fortune.com/2020/04/23/digital-art-blockchain-online-galleries/.

Jesse Einhorn. (2020). *New Balance 650 x No Vacancy Inn IPO Recap - StockX News*. https://stockx.com/news/new-balance-no-vacancy-inn-ipo-recap/.

Jiang, Q., Zhang, Y., & Pian, W. (2022). Chatbot as an emergency exist: Mediated empathy for resilience via human-AI interaction during the COVID-19 pandemic. *Information Processing & Management*, *59*(6), 103074. <https://doi.org/10.1016/j.ipm.2022.103074>

Josephine Wäktare Heintz. (n.d.). Cleo. In *👀*. http://www.josephineheintzwaktare.com/cleo.

Josh Lovejoy. (n.d.). The UX of AI. In *Google Design*. https://design.google/library/ux-ai.

Josh Luber. (2021). Trading Cards Are Cool Again. In *Trading Cards Are Cool Again*. https://www.tradingcardsarecoolagain.com.

Kanza, S., Bird, C. L., Niranjan, M., McNeill, W., & Frey, J. G. (2021). The AI for Scientific Discovery Network+. *Patterns*, *2*(1), 100162. <https://doi.org/10.1016/j.patter.2020.100162>

Karpus, J., Krüger, A., Verba, J. T., Bahrami, B., & Deroy, O. (2021). Algorithm exploitation: Humans are keen to exploit benevolent AI. *iScience*, *24*(6), 102679. <https://doi.org/10.1016/j.isci.2021.102679>

Kate Moran. (2016). *Designing for Young Adults (Ages 18)*. https://www.nngroup.com/articles/young-adults-ux/.

Kecht, C., Egger, A., Kratsch, W., & Röglinger, M. (2023). Quantifying chatbots’ ability to learn business processes. *Information Systems*, 102176. <https://doi.org/10.1016/j.is.2023.102176>

Khosravi, H., Shum, S. B., Chen, G., Conati, C., Tsai, Y.-S., Kay, J., Knight, S., Martinez-Maldonado, R., Sadiq, S., & Gašević, D. (2022). Explainable Artificial Intelligence in education. *Computers and Education: Artificial Intelligence*, *3*, 100074. <https://doi.org/10.1016/j.caeai.2022.100074>

Kore.ai. (2023). Homepage. In *Kore.ai*. https://kore.ai/.

Leite, M. L., de Loiola Costa, L. S., Cunha, V. A., Kreniski, V., de Oliveira Braga Filho, M., da Cunha, N. B., & Costa, F. F. (2021). Artificial intelligence and the future of life sciences. *Drug Discovery Today*, *26*(11), 2515–2526. <https://doi.org/10.1016/j.drudis.2021.07.002>

Lennart Ziburski. (2018). *The UX of AI*. https://uxofai.com/.

Lew, G., & Schumacher, R. M. J. (2020). *AI and UX: Why artificial intelligence needs user experience*. Apress.
<span class="csl-block">1. Introduction to AI and UX – 2. AI and UX: Parallel Journeys – 3. AI-Enabled Products are Emerging All around Us – 4. Garbage In; Garbage Out – 5. Applying a UX Framework</span>

Lexow, M. (2021). Designing for AI a UX approach. In *Medium*. https://uxdesign.cc/artificial-intelligence-in-ux-design-54ad4aa28762.

Li, T., Vorvoreanu, M., DeBellis, D., & Amershi, S. (2022). Assessing human-AI interaction early through factorial surveys: A study on the guidelines for human-AI interaction. *ACM Transactions on Computer-Human Interaction*.

Li, X., & Sung, Y. (2021). Anthropomorphism brings us closer: The mediating role of psychological distance in User assistant interactions. *Computers in Human Behavior*, *118*, 106680. <https://doi.org/10.1016/j.chb.2021.106680>

Liang, P., Bommasani, R., Lee, T., Tsipras, D., Soylu, D., Yasunaga, M., Zhang, Y., Narayanan, D., Wu, Y., Kumar, A., Newman, B., Yuan, B., Yan, B., Zhang, C., Cosgrove, C., Manning, C. D., Ré, C., Acosta-Navas, D., Hudson, D. A., … Koreeda, Y. (2022). *Holistic Evaluation of Language Models* (No. arXiv:2211.09110). arXiv. <https://arxiv.org/abs/2211.09110>
<span class="csl-block">Comment: Authored by the Center for Research on Foundation Models (CRFM) at the Stanford Institute for Human-Centered Artificial Intelligence (HAI). Project page: https://crfm.stanford.edu/helm/v1.0</span>

Liu, B., & Wei, L. (2021). Machine gaze in online behavioral targeting: The effects of algorithmic human likeness on social presence and social influence. *Computers in Human Behavior*, *124*, 106926. <https://doi.org/10.1016/j.chb.2021.106926>

Liu, S., Fan, L., Johns, E., Yu, Z., Xiao, C., & Anandkumar, A. (2023). *Prismer: A Vision-Language Model with An Ensemble of Experts*. <https://doi.org/10.48550/ARXIV.2303.02506>
<span class="csl-block">OtherTech Report. Project Page: https://shikun.io/projects/prismer Code: https://github.com/NVlabs/prismer</span>

Lorenzo, D., Lorenzo, D., & Lorenzo, D. (2015). Daisy Ginsberg Imagines A Friendlier Biological Future. In *Fast Company*. https://www.fastcompany.com/3051140/daisy-ginsberg-is-natures-most-deadly-synthetic-designer.

Lower, C. (2017). Chatbots: Too Good to Be True? (They Are, Here’s Why). In *Clinc*.

Lv, X., Luo, J., Liang, Y., Liu, Y., & Li, C. (2022). Is cuteness irresistible? The impact of cuteness on customers’ intentions to use AI applications. *Tourism Management*, *90*, 104472. <https://doi.org/10.1016/j.tourman.2021.104472>

Martínez-Plumed, F., Gómez, E., & Hernández-Orallo, J. (2021). Futures of artificial intelligence through technology readiness levels. *Telematics and Informatics*, *58*, 101525. <https://doi.org/10.1016/j.tele.2020.101525>

Microsoft. (2023). *Microsoft Designer - Stunning designs in a flash*.

Mikael Eriksson Björling, & Ahmed H. Ali. (n.d.). UX design in AI, A trustworthy face for the AI brain. In *Ericsson*.

Mohit Moondra. (n.d.). Navigate more sustainably and optimize for fuel savings with eco-friendly routing. In *Google Cloud Blog*. https://cloud.google.com/blog/products/maps-platform/navigate-more-sustainably-and-optimize-fuel-savings-eco-friendly-routing.

Natasha Mascarenhas. (2021). Queenly’s marketplace for formalwear gets millions in round led by A16z \| TechCrunch. *TechCrunch*.

Nathan Benaich, & Ian Hogarth. (2022). *State of AI Report 2022*. https://www.stateof.ai/.

NeuralNine. (2021). *Financial AI Assistant in Python*.

O’Connor, S., & ChatGPT. (2023). Open artificial intelligence platforms in nursing education: Tools for academic progress or abuse? *Nurse Education in Practice*, *66*, 103537. <https://doi.org/10.1016/j.nepr.2022.103537>

OpenSea. (2022). Top Taiwan Influencers - Collection. In *OpenSea*. https://opensea.io/collection/top-taiwan-influencers.

Orozco, L. G. N., Battiston, F., Iñiguez, G., & Szell, M. (2020). *Budapest bicycle network growth; Manhattan bicycle network growth from <span class="nocase">Data-driven</span> strategies for optimal bicycle network growth*. 7642364 Bytes. <https://doi.org/10.6084/M9.FIGSHARE.13336684.V1>

patrizia-slongo. (2020). <span class="nocase">AI-powered</span> tools for web designers 🤖. In *Medium*. https://blog.prototypr.io/ai-powered-tools-for-web-designers-adc97530a7f0.

Pavlik, J. V. (2023). Collaborating With ChatGPT: Considering the Implications of Generative Artificial Intelligence for Journalism and Media Education. *Journalism & Mass Communication Educator*, *78*(1), 84–93. <https://doi.org/10.1177/10776958221149577>

Pete. (2023). We hosted #emergencychatgpthackathon this past Sunday for the new ChatGPT and Whisper APIs. It all came together in just 4 days, but we had 250+ people and 70+ teams demo! Here’s a recap of our winning demos: <span class="nocase">https://t.co/6o1PvR9gRJ</span> \[Tweet\]. In *Twitter*.

🧠Psychology of Design: 106 Cognitive Biases & Principles That Affect Your UX. (n.d.). In *Growth.Design*. https://growth.design/psychology/.

Qorus. (2023). *The Great Reinvention: The Global Digital Banking Radar 2023*.

Ramchurn, S. D., Stein, S., & Jennings, N. R. (2021). Trustworthy human-AI partnerships. *iScience*, *24*(8), 102891. <https://doi.org/10.1016/j.isci.2021.102891>

ReadyAI. (2020). *Human-AI Interaction: How We Work with Artificial Intelligence*.

Rogers, Y. (2022). The Four Phases of Pervasive Computing: From Vision-Inspired to Societal-Challenged. *IEEE Pervasive Comput.*, *21*(3), 9–16. <https://doi.org/10.1109/MPRV.2022.3179145>

Roland Meyer. (2023). Now that the DALL-E has been successfully midjourneyfied, it is becoming apparent that instead of simulating all possible styles, AI is fostering the emergence of a distinct visual style, born out of popular aesthetic preferences dominating platforms like DeviantArt 1/6 <span class="nocase">https://t.co/tZd9Hrz27s</span> \[Tweet\]. In *Twitter*.

Rooney-Varga, J., Kapmeier, F., Sterman, J., Jones, A., Putko, M., & Rath, K. (2019). The climate action simulation. *Simulation & Gaming*, *51*, 104687811989064. <https://doi.org/10.1177/1046878119890643>

Ross, L., Arrow, K., Cialdini, R., Diamond-Smith, N., Diamond, J., Dunne, J., Feldman, M., Horn, R., Kennedy, D., Murphy, C., Pirages, D., Smith, K., York, R., & Ehrlich, P. (2016). The Climate Change Challenge and Barriers to the Exercise of Foresight Intelligence. *BioScience*, *66*(5), 363–370. <https://doi.org/10.1093/biosci/biw025>

Schoonderwoerd, T. A. J., Jorritsma, W., Neerincx, M. A., & van den Bosch, K. (2021). Human-centered XAI: Developing design patterns for explanations of clinical decision support systems. *International Journal of Human-Computer Studies*, *154*, 102684. <https://doi.org/10.1016/j.ijhcs.2021.102684>

Seeber, I., Bittner, E., Briggs, R. O., de Vreede, T., de Vreede, G.-J., Elkins, A., Maier, R., Merz, A. B., Oeste-Reiß, S., Randrup, N., Schwabe, G., & Söllner, M. (2020). Machines as teammates: A research agenda on AI in team collaboration. *Information & Management*, *57*(2), 103174. <https://doi.org/10.1016/j.im.2019.103174>

September 16, 2020. (2020). *What is <span class="nocase">AI-assisted Design</span>? \| Renumics GmbH*. https://renumics.com/blog/what-is-ai-assisted-design/.

Şerban, C., & Todericiu, I.-A. (2020). Alexa, what classes do I have today? The use of artificial intelligence via smart speakers in education. *Procedia Computer Science*, *176*, 2849–2857. <https://doi.org/10.1016/j.procs.2020.09.269>
<span class="csl-block">Knowledge-Based and Intelligent Information & Engineering Systems: Proceedings of the 24th International Conference KES2020</span>

Shenoi, S. (2018). Participatory design and the future of interaction design. In *Medium*. https://uxdesign.cc/participatory-design-and-the-future-of-interaction-design-81a11713bbf.

Shin, D. (2020). How do users interact with algorithm recommender systems? The interaction of users, algorithms, and performance. *Computers in Human Behavior*, *109*, 106344. <https://doi.org/10.1016/j.chb.2020.106344>

Shin, D., Zhong, B., & Biocca, F. (2020). Beyond user experience: What constitutes algorithmic experiences? *International Journal of Information Management*, *52*, 102061. <https://doi.org/10.1016/j.ijinfomgt.2019.102061>

Singer, U., Polyak, A., Hayes, T., Yin, X., An, J., Zhang, S., Hu, Q., Yang, H., Ashual, O., Gafni, O., Parikh, D., Gupta, S., & Taigman, Y. (2022). Make-<span class="nocase">A-video</span>: <span class="nocase">Text-to-video</span> generation without text-video data. *ArXiv*, *abs/2209.14792*.

Slack, J. (2021). The Atura Process. In *Atura website*. https://atura.ai/docs/02-process/.

Soleimani, L. (2018). 10 UI Patterns For a Human Friendly AI. In *Medium*. https://blog.orium.com/10-ui-patterns-for-a-human-friendly-ai-e86baa2a4471.

Stanford Encyclopedia of Philosophy. (2021). *The Turing Test*. https://plato.stanford.edu/entries/turing-test/.

Steph Hay. (2017). Eno - Financial AI Understands Emotions. In *Capital One*. https://www.capitalone.com/tech/machine-learning/designing-a-financial-ai-that-recognizes-and-responds-to-emotion/.

Stephanie Donahole. (2021). How Artificial Intelligence Is Impacting UX Design. In *UXmatters*. https://www.uxmatters.com/mt/archives/2021/04/how-artificial-intelligence-is-impacting-ux-design.php.

Stone Skipper. (2022). How AI is changing “interactions.” In *Medium*. https://uxplanet.org/how-ai-is-changing-interactions-179cc279e545.

*Studies in conversational UX design*. (2018). \[Computer software\]. Springer Berlin Heidelberg.

Su, J., Ng, D. T. K., & Chu, S. K. W. (2023). Artificial Intelligence (AI) Literacy in Early Childhood Education: The Challenges and Opportunities. *Computers and Education: Artificial Intelligence*, *4*, 100124. <https://doi.org/10.1016/j.caeai.2023.100124>

Su, J., & Yang, W. (2022). Artificial intelligence in early childhood education: A scoping review. *Computers and Education: Artificial Intelligence*, *3*, 100049. <https://doi.org/10.1016/j.caeai.2022.100049>

Suen, H.-Y., & Hung, K.-E. (2023). Building trust in automatic video interviews using various AI interfaces: Tangibility, immediacy, and transparency. *Computers in Human Behavior*, *143*, 107713. <https://doi.org/10.1016/j.chb.2023.107713>

*Sustainable Shopping: Saving and Investing for a Greener Tomorrow*. (2023). https://www.bedimestory.ai/krishaamer/story/SqNAYjZ\_.

Szczuka, J. M., Strathmann, C., Szymczyk, N., Mavrina, L., & Krämer, N. C. (2022). How do children acquire knowledge about voice assistants? A longitudinal field study on children’s knowledge about how voice assistants store and process data. *International Journal of Child-Computer Interaction*, *33*, 100460. <https://doi.org/10.1016/j.ijcci.2022.100460>

Tamkin, A., Brundage, M., Clark, J., & Ganguli, D. (2021). *Understanding the capabilities, limitations, and societal impact of large language models*. arXiv. <https://doi.org/10.48550/arxiv.2102.02503>

Tang, J., LeBel, A., Jain, S., & Huth, A. G. (2022). *Semantic reconstruction of continuous language from non-invasive brain recordings* \[Preprint\]. Neuroscience. <https://doi.org/10.1101/2022.09.29.509744>

Tash Keuneman. (2020). Dear fitness tracker designers. In *Medium*. https://uxdesign.cc/dear-fitness-tracker-designers-7a9bf654071a.

Tash Keuneman. (2022). We love to hate Clippy but what if Clippy was right? In *UX Collective*. https://uxdesign.cc/we-love-to-hate-clippy-but-what-if-clippy-was-right-472883c55f2e.

*The A-Z of AI*. (n.d.). https://atozofai.withgoogle.com/.

The International Ergonomics Association. (2019). *Human Factors/Ergonomics (HF/E)*. https://iea.cc/what-is-ergonomics/.

Tom Hathaway, & Angela Hathaway. (2021). *Chatting with Humans: User Experience Design (UX) for Chatbots: Simplified Conversational Design and <span class="nocase">Science-based Chatbot Copy</span> that Engages People*.

Tristan Greene. (2022). Confused Replika AI users are trying to bang the algorithm. In *TNW*. https://thenextweb.com/news/confused-replika-ai-users-are-standing-up-for-bots-trying-bang-the-algorithm.

Tubik Studio. (2018). UX Design Glossary: How to Use Affordances in User Interfaces. In *Medium*. https://uxplanet.org/ux-design-glossary-how-to-use-affordances-in-user-interfaces-393c8e9686e4.

Turing, A. M. (1950). I. *Mind*, *LIX*(236), 433–460. <https://doi.org/10.1093/mind/LIX.236.433>

Unleash. (2017). Sebastian.ai. In *UNLEASH*.

van Wynsberghe, A. (2021). Sustainable AI: AI for sustainability and the sustainability of AI. *AI Ethics*, *1*(3), 213–218. <https://doi.org/10.1007/s43681-021-00043-6>

Veitch, E., & Andreas Alsos, O. (2022). A systematic review of human-AI interaction in autonomous ship systems. *Safety Science*, *152*, 105778. <https://doi.org/10.1016/j.ssci.2022.105778>

VideoLecturesChannel. (2022). *Communication in Human-AI Interaction*.

Vinuesa, R., Azizpour, H., Leite, I., Balaam, M., Dignum, V., Domisch, S., Felländer, A., Langhans, S. D., Tegmark, M., & Fuso Nerini, F. (2020). The role of artificial intelligence in achieving the Sustainable Development Goals. *Nat Commun*, *11*(1), 233. <https://doi.org/10.1038/s41467-019-14108-y>

Wang, Z., She, Q., Smeaton, A. F., Ward, T. E., & Healy, G. (2020). Synthetic-Neuroscore: Using a neuro-AI interface for evaluating generative adversarial networks. *Neurocomputing*, *405*, 26–36. <https://doi.org/10.1016/j.neucom.2020.04.069>

Why UX should guide AI. (2021). In *VentureBeat*.

Women in AI. (n.d.). How can AI assistants help patients monitor their health? In *Spotify*. https://open.spotify.com/episode/3dL4m7ciCY0tnirZT2emzs.

Yang, W. (2022). Artificial Intelligence education for young children: Why, what, and how in curriculum design and implementation. *Computers and Education: Artificial Intelligence*, *3*, 100061. <https://doi.org/10.1016/j.caeai.2022.100061>

Yuan, C., Zhang, C., & Wang, S. (2022). Social anxiety as a moderator in consumer willingness to accept AI assistants based on utilitarian and hedonic values. *Journal of Retailing and Consumer Services*, *65*, 102878. <https://doi.org/10.1016/j.jretconser.2021.102878>

Zafar, N., & Ahamed, J. (2022). Emerging technologies for the management of COVID19: A review. *Sustainable Operations and Computers*, *3*, 249–257. <https://doi.org/10.1016/j.susoc.2022.05.002>

Zakariya, C. (2022). Stop Using Jasper Art: Use the New Canva AI Image Generator \[Video\]. In *ILLUMINATION*.

Zerilli, J., Bhatt, U., & Weller, A. (2022). How transparency modulates trust in artificial intelligence. *Patterns*, *3*(4), 100455. <https://doi.org/10.1016/j.patter.2022.100455>

Zhang, G., Chong, L., Kotovsky, K., & Cagan, J. (2023). Trust in an AI versus a Human teammate: The effects of teammate identity and performance on Human-AI cooperation. *Computers in Human Behavior*, *139*, 107536. <https://doi.org/10.1016/j.chb.2022.107536>

Zhang, S. (2018). *Personal Carbon Economy*. http://www.shihanzhang.com/new-page-3.

Zimmerman, J., Oh, C., Yildirim, N., Kass, A., Tung, T., & Forlizzi, J. (2021). UX designers pushing AI in the enterprise: A case for adaptive UIs. *Interactions*, *28*(1), 72–77. <https://doi.org/10.1145/3436954>
