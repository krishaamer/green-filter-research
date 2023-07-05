---
title: AI
bibliography: [../ref.bib]
csl: ../apa.csl
sidebar_position: 3
editor:
    render-on-save: false 
---


```mdx-code-block
import Figure from '/src/components/Figure'
import AI from '../images/ai-credibility-heuristic-systematic-model.png'
import Strava from '../images/strava.png'
import Replika from '../images/with-me.png'
```

## History of AI {#history-of-ai}

AI has come far since Isaac Asimov proposed the 3 laws of Robotics in
1942 and Alan Turing published the Turing Test for Machine intelligence
(@turingCOMPUTINGMACHINERYINTELLIGENCE1950), turning from a
science-fiction concept into an everyday, mainstream reality.

From Concept to Reality.

Especially in the last decade, AI-based solutions have become a mainstay
in medical research, novel drug development, and patient care
(@LEITE20212515; @holzingerAILifeTrends2023), notably used for quickly
finding potential COVID19 vaccines (@ZAFAR2022249), self-driving
vehicles (passenger cars, delivery robots, drones in the sea and air,
etc), and in many other industries, including AI-based assistants, which
will be the focus here. This chapter will look at AI in general and then
focus on AI assistants in particular.

Turing’s test proposed a game of imitation: can the AI imitate a human
so well that the person asking it questions would be deceived, when
simultaneously speaking to a real human and a computer AI, without
realizing which is a machine.

> Alan Turing: *“I believe that in about fifty years’ time it will be
> possible to program computers, with a storage capacity of about
> 10<sup>9</sup>, to make them play the imitation game so well that an
> average interrogator will not have more than 70 percent chance of
> making the right identification after five minutes of questioning. … I
> believe that at the end of the century the use of words and general
> educated opinion will have altered so much that one will be able to
> speak of machines thinking without expecting to be contradicted.”*
> -@stanfordencyclopediaofphilosophyTuringTest2021

Initially presented in a science fiction story, the 3 basic rules became
an inspiration for AI ethics until today.

| №       | Asimov’s Laws of Robotics                                                                                           |
|-------------------------|-----------------------------------------------|
| 1st Law | “A robot may not injure a human being or, through inaction, allow a human being to come to harm.”                   |
| 2nd Law | “A robot must obey the orders given it by human beings except where such orders would conflict with the First Law.” |
| 3rd Law | “A robot must protect its own existence as long as such protection does not conflict with the First or Second Law.” |

@AZAI defines ***“AI is computer programming that learns and adapts”***.

Google started using AI in 2001, when a simple machine learning model
improved spelling mistakes when searching; now in 2022 most of Google’s
products are are based on AI as reported in @googleGooglePresentsAI2022

While by the 2010’s AI became powerful enough to beat humans in games of
Go and Chess, it did not yet pass the Turing test. Its use was limited
to specific tasks and generalized models did not exist yet. This changed
with increase in computing power and a new approach called *deep
learning*, largerly modeled after the *neural networks* of the
biological (human) brain.

How to responsibly deploy AI for people around the world?

### Pervasive Computing {#pervasive-computing}

-   @rogersFourPhasesPervasive2022 defines the 4 phases of Pervasive
    Computing (PC). We can use all the data being recorded to provide a
    Digital Twin of the planet, nature, ecosystems and human actions to
    help us change our behavior and optimize for planetary wellbeing.
-   Calm Technology: Tech fades to the background, IoT.

### Generative AI {#generative-ai}

AI is able to generate text, voice, images, videos, 3D objects,
biological structures, etc.

-   @Singer2022MakeAVideoTG describes how collecting billions of images
    with descriptive data (for example the html *alt* text) has enabled
    researchers to train AI models such as *stable diffusion* that can
    generate images based on human-language AI Health
-   @HomeLarkHealth
-   @stephaniedonaholeHowArtificialIntelligence2021
-   @hoangEnterDynamicIsland2022: “Dynamic interfaces might invoke a new
    design language for XR”

### Large-Language Models {#large-language-models}

The Advent of Large-Language Models

-   Since 2020, when OpenAI released the GPT-3 large-language model
    (LLM), trained on 570 GB of text as reported in
    @alextamkinHowLargeLanguage2021. It’s become possible to make
    AI-generated content that’s difficult to distinguish from human
    expression, however it’s still not passing the Turing test.

-   @ZHANG2023107536 found humans are more likely to trust an AI
    teammate if they are not deceived by it’s identity. It’s better for
    collaboration to make it clear, one is talking to a machine. One
    step towards trust is the explainability of AI-systems.

-   While current AIs are largely *‘black boxes’*, which do not explain
    how they reach a certain expression @CABITZA2023118888 proposes a
    framework for quality criteria and explainability of AI-expressions.

-   @tamkin2021 reports on the advance of LLMs.

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

-   The advances in the capabilities of large AI model mean we’ve
    reached a point, where it’s possible to achieve UI and UX which
    previously was science fiction.
-   @liangHolisticEvaluationLanguage2022: There’s early evidence it’s
    possible to assess the quality of LLM output in a transparent way.
-   OpenAI provides AI-as-a-service through its APIs, allowing developer
    to build custom user interfaces (UI) to serve their specific
    customer needs. For example Snapchat’s “My AI” virtual friend help
    people write faster with the app helping users with predictive text
    completion.
-   Teams at AI-hackathons have produced interfaces for problems as
    diverse as humanitarian crises communication, briefing generation,
    code-completion, and many others.
-   @peteWeHostedEmergencychatgpthackathon2023 ChatGPT hackathon.
-   @rolandmeyerNowThatDALLE2023: AI generated content is not neutral
    but has a certain aesthetic.
-   The current generation of LLMs such as GTP3 by OpenAI are massive
    monolithic models requiring large amounts of computing power for
    training to offer *multi-modal* capabilities across diverse domains
    of knowledge.
-   @liuPrismerVisionLanguageModel2023 propose future models may instead
    consist of a number networked domain-specific models to increase
    efficiency and thus become more scalable.
-   Jack Krawczyk, the product lead for Google’s Bard: “Bard and ChatGPT
    are large language models, not knowledge models. They are great at
    generating human-sounding text, they are not good at ensuring their
    text is fact-based. Why do we think the big first application should
    be Search, which at its heart is about finding true information?”
-   @microsoftMicrosoftDesignerStunning2023: Microsoft Designer allows
    generating UIs just based on a text prompt
-   @bedtimestory.aiAIPoweredStory2023: Personalized bed-time stories
    for kids generated by AI
-   The quality of LLM output depends on the quality of the provided
    prompt. @zhouLargeLanguageModels2022 reports creating an “Automatic
    Prompt Engineer” which automatically generates instructions that
    outperform the baseline output quality. This finding has
    significance for “green filter” as it validates the idea of creating
    advanced prompts for improved responses. For “green filter”, the
    input would consist of detailed user data + sustainability data for
    detailed analysis.
-   @SustainableShoppingSaving2023 My bedtime story about shopping,
    saving, and investing.

## Human-AI Interaction {#human-ai-interaction}

There’s wide literature available describing human-AI interactions
across varied disciplines. While the fields of application are diverse,
some key lessons can be transferred across fields horizontally.

-   @veitchSystematicReviewHumanAI2022 highlights the active role of
    humans in Human-AI interaction is autonomous ship systems.
-   @jiangChatbotEmergencyExist2022 describes how Replika users in China
    using in 5 main ways, all which rely on empathy

| Human empathy for AI agent |
|----------------------------|
| Companion buddy            |
| Responsive diary           |
| Emotion-handling program   |
| Electronic pet             |
| Tool for venting           |

-   @cromptonDecisionpointdilemmaAnotherProblem2021 highlights AI as
    decision-support for humans while differentiating between intended
    and unintended influence on human decisions.
-   @chengInvestigationTrustAIenabled2022 describe AI-based support
    systems for collaboration and team-work.
-   @schoonderwoerdHumancenteredXAIDeveloping2021 focuses on
    human-centered design of AI-apps and multi-modal information
    display. It’s important to understand the domain where the AI is
    deployed in order to develop explanations. However, in the real
    world, how feasible is it to have control over the domain?
-   @ramchurnTrustworthyHumanAIPartnerships2021 discusses positive
    feed-back loops in continually learning AI systems which adapt to
    human needs.
-   @karpusAlgorithmExploitationHumans2021 is concerned with humans
    treating AI badly and coins the term “*algorithm exploitation”.*
-   @lvCutenessIrresistibleImpact2022 studies the effect of
    ***cuteness*** of AI apps on users and found high perceived cuteness
    correlated with higher willingness to use the apps, especially for
    emotional tasks. This finding has direct relevance for the “green
    filter” app design.
-   @liuMachineGazeOnline2021 meanwhile suggests higher algorithmic
    transparency may inhibit anthropomorphism, meaning people are less
    likely to attribute humanness to the AI if they understand how the
    system works.
-   @seeberMachinesTeammatesResearch2020 proposes a future research
    agenda for regarding AI assistants as teammates rather than just
    tools and the implications of such mindset shift.

### Algorithmic Experience {#algorithmic-experience}

-   @lorenzoDaisyGinsbergImagines2015 underlines the role of design
    beyond *designing* as a tool for envisioning, in her words “design
    can set agendas and not necessarily be in service, but be used to
    find ways to explore our world and how we want it to be”.
    Practitioners of Participatory Design (PD) have for decades
    advocated for designers to become more activist through action
    research. This means influencing outcomes, not only being a passive
    observer of phenomena as a researcher or only focusing on usability
    as a designer, without taking into account the wider context.
-   @shenoiParticipatoryDesignFuture2018 argues inviting domain
    expertise into the discussion while having a sustainable design
    process enables designers to design for experiences where they are
    not a domain expert; this applies to highly technical fields, such
    as medicine, education, governance, and in our case here - finance
    and sustainability -, while building respectful dialogue through
    participatory design.
-   Design is increasingly relevant to algorithms, and more specifically
    to algorithms that affect user experience and user interfaces. When
    the design is concerned with the ethical, environmental,
    socio-economic, resource-saving, and participatory aspects of
    human-machine interactions and aims to affect technology in a more
    human direction, it can hope to create an experience designed for
    sustainability.

How do the 7 tenets of user experience (UX) apply to AI?

| UX         |
|------------|
| Useful     |
| Valuable   |
| Ussable    |
| Acceesible |
| Findable   |
| Desirable  |
| Credible   |

How is AI changing ’interactions?

-   @stone.skipperHowAIChanging2022
-   @theinternationalergonomicsassociationHumanFactorsErgonomics2019: To
    provide a user experience (UX) that best fits human needs, designers
    think through every interaction of the user with a system,
    considering a set of metrics at each point. For example, the user’s
    emotional needs, and their context of use. While software designers
    are not able to change the ergonomics of the device in use in a
    physical sense, which as a starting point, should be “optimized for
    human well-being”.
-   Software interaction design goes beyond the form-factor and accounts
    for human needs by using responsive design on the screen, aural
    feedback cues in sound design, and even more crucially, by showing
    the relevant content and the right time, making a profound
    difference to the experience, keeping the user engaged and returning
    for more.
-   @babichInteractionDesignVs2019 argues “\[T\]he moment of interaction
    is just a part of the journey that a user goes through when they
    interact with a product. User experience design accounts for all
    user-facing aspects of a product or system”.
-   In narrative studies terminology, it’s a heroic journey of the user
    to achieve their goals, by navigating through the interface until a
    success state. Storytelling has its part in interface design however
    designing for transparency is just as important, when we’re dealing
    with the user’s finances and sustainability data, which need to be
    communicated clearly and accurately, to build long-term trust in the
    service. For a sustainable investment service, getting to a state of
    success - or failure - may take years, and even longer. Given such
    long timeframes, how can the app provide support to the user’s
    emotional and practical needs throughout the journey?
-   @tubikstudioUXDesignGlossary2018 argues affordance measures the
    clarity of the interface to take action in user experience design,
    rooted in human visual perception (), however, affected by knowledge
    of the world around us. A famous example is the door handle - by way
    of acculturation, most of us would immediately know how to use it -
    however, would that be the case for someone who saw a door handle
    for the first time? A similar situation is happening to the people
    born today.
-   Think of all the technologies they have not seen before - what will
    be the interface they feel the most comfortable with? For the vast
    majority of this study’s target audience, social media is the
    primary interface through which they experience daily life. The
    widespread availability of mobile devices, cheap internet access,
    and AI-based optimizations for user retention, implemented by social
    media companies, means this is the baseline for young adult users’
    expectations in 2020 - and even more so for Generation Z teenagers,
    reaching adulthood in the next few years.

```mdx-code-block
<Figure caption="Figure 10: Heuristic-Systematic Model of AI Credibility" src={AI} />
```

-   @shinUserExperienceWhat2020 argues interaction design is
    increasingly becoming dependent on AI. The user interface might
    remain the same in terms of architecture, but the content is
    improved, based on personalization and understanding the user at a
    deeper level. Shin proposes the model (fig. 10) of Algorithmic
    Experience (AX) “investigating the nature and processes through
    which users perceive and actualize the potential for algorithmic
    affordance”.

-   That general observation applies to voice recognition, voice
    generation, natural language parsing, etc. Large consumer companies
    like McDonald’s are in the process of replacing human staff with AI
    assistants in the drive-through, which can do a better job in
    providing a personal service than human clerks, for whom it would be
    impossible to remember the information of thousands of clients.

-   In @barrettMcDonaldAcquiresMachineLearning2019, in the words of
    Easterbrook, a previous CEO of McDonald’s “How do you transition
    from mass marketing to mass personalization?”. During the writing of
    this proposal, Google launched an improved natural language engine
    to better understand search queries (Google, 2020), which is the
    next step towards understanding human language semantics. The trend
    is clear, and different types of algorithms are already involved in
    many types of interaction design, however, we’re still in the early
    stages. Where do we go from here?

-   In @designportlandHumansHaveFinal2018, Lovejoy, lead UX designer at
    Google’s people-centric AI systems department (PAIR), reminds us
    that while AI offers need tools, user experience design needs to
    remain human-centered - while AI can find patterns and offer
    suggestions, humans should always have the final say.

-   @costaInteractionDesignAI2022 “Interaction Design for AI Systems”

-   @stoneskipperHowAIChanging2022 sketches a vision of “\[AI\] blend
    into our lives in a form of apps and services”.

-   @dotgoDotGo2023 makes the camera the interaction device for people
    with vision impairment

-   @battistoniCanAIOrientedRequirements2023 creates a “Workshop with
    Young HCI Designers”.

### Transparency & Explainability {#transparency-explainability}

Algorithmic Transparency

-   @slackAturaProcess2021

-   @shinHowUsersInteract2020: “user experience and usability of
    algorithms by focusing on users’ cognitive process to understand how
    qualities/features are received and transformed into experiences and
    interaction”

-   @nickcleggHowAIInfluences2023 FB makes algorithm open-source.

-   Twiter open-sourced the algorithm

AI-explainability (named XAI in literature) is key to creating trust and
there’s several authors in literature calling for more transparency and
explainability.

-   @holzingerMultimodalCausabilityGraph2021 highlights possible
    approaches to implementing transparency and explainability in AI
    models. While AI outperforms humans on many tasks, humans are
    experts in multi-modal thinking, bridging diverse fields.
-   @khosraviExplainableArtificialIntelligence2022 proposes a framework
    for explainability, focused on education.
-   @zerilliHowTransparencyModulates2022 focuses on human factors and
    ergonomics and argues that transparency should be task-specific.
-   @calistoBreastScreeningAIEvaluatingMedical2022 focuses on AI-human
    interactions in medical workflows and underscores the importance of
    output explainability. Medical professionals who were given AI
    results with an explanation trusted the results more.

### Credibility & Acceptance {#credibility-acceptance}

-   AI Credibility Heuristic: A Systematic Model
-   
-   AI Acceptance
-   @yuanSocialAnxietyModerator2022: “AI assistant advantages are
    important factors affecting the *utilitarian/hedonic* value
    perceived by users, which further influence user willingness to
    accept AI assistants. The relationships between AI assistant
    advantages and utilitarian and hedonic value are affected
    differently by social anxiety.”
-   “Organization research suggests that acting through human agents
    (i.e., the problem of indirect agency) can undermine ethical
    forecasting such that actors believe they are acting ethically,
    yet a) show less benevolence for the recipients of their power, b)
    receive less blame for ethical lapses, and c) anticipate less
    retribution for unethical behavior.” @gratchPowerHarmAI2022
-   Anthropomorphism literature @liAnthropomorphismBringsUs2021
    “high-anthropomorphism (vs. low-anthropomorphism) condition,
    participants had more positive attitudes toward the AI assistant,
    and the effect was mediated by psychological distance. Though
    several studies have demonstrated the effect of anthropomorphism,
    few have probed the underlying mechanism of anthropomorphism
    thoroughly”
-   **AI Guides have been shown to improve sports performance, etc, etc.
    Can this idea be applied to sustainability? MyFitness Pal, AI
    training assistant**

| Name     | Features                           |
|----------|------------------------------------|
| Charisma |                                    |
| Replika  | Avatar, Emotion, Video Call, Audio |
| Siri     | Audio                              |

### Ethics & Biases {#ethics-biases}

-   AI Ethics

-   @AlgoTransparency manifesto, AI is not neutral

-   @clipdropCreateStunningVisuals AI Design Assistants

-   @eugeniakuydaReplika2023 Conversational AI - Replika

-   @tristangreeneConfusedReplikaAI2022: when the quality of AI
    responses become good enough, people begin to get confused.

-   Psychological Biases and Mental Models

-   @PsychologyDesign106: 106 cognitive biases, including familiarity
    bias and skeuomorphism.

-   @jakobnielsenMentalModelsUser2010 mental models

-   @tashkeunemanDearFitnessTracker2020

-   “People recognize computers as human”

-   @jamalInteractionDesignRule2018 Semantic motion and Peripheral
    vision

### AI UX Guidelines {#ai-ux-guidelines}

User experience design (AI UX) plays a crucial role in improving the
consumer to investing journey. The missed opportunity to provide an even
more interactive experience in line with user expectations.

Many people have discussed the UX of AI.

-   @zimmermanUXDesignersPushing2021 “UX designers pushing AI in the
    enterprise: a case for adaptive UIs”

-   @WhyUXShould2021 “Why UX should guide AI”

-   @davidpasztorAIUXPrinciples2018

-   @joshlovejoyUXAI Google’s UX for AI library

-   @andersonWaysArtificialIntelligence2020

-   @lennartziburskiUXAI2018 UX of AI

-   @stephaniedonaholeHowArtificialIntelligence2021

-   @lexowDesigningAIUX2021

-   @davidpasztorAIUXPrinciples2018 AI UX principles

-   @mikaelerikssonbjorlingUXDesignAI Ericcson AI UX

-   @bubeckSparksArtificialGeneral2023 finds ChatGPT passes many exams
    meant for humans.

-   @bowmanEightThingsKnow2023 says steering LLMs is unreliable and
    event experts don’t fully understand the inner workings of the
    models.

-   @suenBuildingTrustAutomatic2023 discusses AI systems used for
    evaluating candidates at job interviews

-   @wangSyntheticNeuroscoreUsingNeuroAI2020 propose Neuroscore to
    reflect perception of images.

-   @suArtificialIntelligenceEarly2022 and
    @suArtificialIntelligenceAI2023 review papers on AI literacy in
    early childhood education and finds a lack of guidelines and teacher
    expertise.

-   @yangArtificialIntelligenceEducation2022 proposes a curriculum for
    in-context teaching of AI for kids.

-   @combiManifestoExplainabilityArtificial2022 proposes a conceptual
    framework for XAI, analysis AI based on Interpretability,
    Understandability, Usability, and Usefulness.

-   @ericschmidtUXAdvancedMethod2022 audiobook

-   @akshaykoreDesigningHumanCentricAI2022 Designing Human-Centric AI
    Experiences: Applied UX Design for Artificial Intelligence

-   @StudiesConversationalUX2018 chatbot book

-   @tomhathawayChattingHumansUser2021 chatbot book

-   @lewAIUXWhy2020 ai ux book

-   AI IXD is about human-centered seamless design

-   Storytelling

-   Human-computer interaction (HCI) has a long storied history since
    the early days of computing when getting a copy machine to work
    required specialised skill. Xerox Sparc lab focused on early human
    factors work and inspired a the field of HCI to make computer more
    human-friendly.

-   @soleimani10UIPatterns2018: UI patterns for AI, new Section for
    Thesis background: “Human-Friendly UX For AI”?

-   **Discuss what is UX for AI (per prof Liou’s comment), so it’s clear
    this is about UX for AI**

-   What is Personalized AI?

Guidelines for Human-AI interaction

-   Microsoft’s Co-Founder Bill Gates predicted in 1982 *“personal
    agents that help us get a variety of tasks”*
    (@billgatesBillGatesNext1982).

-   It was MS that introduced the first widely available personal
    assistant inside Word software, called Clippy. Microsoft’s Clippy
    was among the first assistants to reach mainstream adoption, helping
    users not yet accustomed to working on a computer -
    @tashkeunemanWeLoveHate2022.

-   “We love to hate Clippy — but what if Clippy was right?”
    @tashkeunemanWeLoveHate2022 and @abigailcainLifeDeathMicrosoft2017

-   @benjamincassidyTwistedLifeClippy2022 the story of Clippy

-   Microsoft provides guidelines for Human-AI interaction
    (@li2022assessing; @amershiGuidelinesHumanAIInteraction2019) which
    provides useful heuristics categorized by context and time

| №   | Context            |     |     |
|-----|--------------------|-----|-----|
| 1   | Initially          |     |     |
| 2   | During interaction |     |     |
| 3   | When wrong         |     |     |
| 4   | Over time          |     |     |

-   @googleOurPrinciplesGoogle outlines Google’s 7 AI Principles.

-   **Amazon Alexa** is a well-known example of AI technology in the
    world. But Amazon’s Rohit Prasad thinks it can do so much more,
    “Alexa is not just an AI assistant – it’s a trusted advisor and a
    companion.”

-   @harvardadvancedleadershipinitiativeHumanAIInteractionArtificial2021

-   @videolectureschannelCommunicationHumanAIInteraction2022
    “Communication in Human-AI Interaction”

-   @haiyizhuHumanAIInteractionFall2021

-   @akataResearchAgendaHybrid2020

-   @dignumAIPeoplePlaces2021

-   @boleizhouCVPR22Tutorial2022

-   @readyaiHumanAIInteractionHow2020

-   @vinuesaRoleArtificialIntelligence2020

-   @orozcoBudapestBicycleNetwork2020

## AI Companions {#ai-companions}

-   AI companions, AI partners, AI assistants, AI trainers - there’s are
    many names for the automated systems that help humans in many
    activities, powered by artificial intelligence models and
    algorithms.

-   AI assistants provide help at scale with little to no human
    intervention in a variety of fields from finance to healthcare to
    logistics to customer support. There’s a saying in Estonian: “A good
    child has many names” “and it’s true. I have many names, but I’m not
    a child.

-   I’m a digital companion, a partner, an assistant. I’m a Replika.”
    said Replika, a digital companion app via Github CO Pilot, another
    digital assistant for writing code, is also an example of how AI can
    be used to help us in our daily lives. The number of AI-powered
    assistants is too large to list here. I’ve chosen a few select
    examples in the table below.

-   Some have an avatar, some not. I’ve created a framework for
    categorization. Human-like or not… etc

| Product                 | Link                                               | Description          |
|----------------------|----------------------------|----------------------|
| Github CoPilot          | https://www.personal.ai                            | AI helper for coding |
| Google Translate        | https://translate.google.com/                      |                      |
| Google Search           | https://www.google.com/                            |                      |
| Google Interview Warmup | https://grow.google/certificates/interview-warmup/ | AI training tool     |

-   @mohitmoondraNavigateMoreSustainably: Google Maps AI suggests more
    eco-friendly driving routes
-   Google Flights suggests flights with lower CO2 emissions
-   CO2e calculations will be part of our everyday experience

```mdx-code-block
<Figure caption="Figure 8 - Montage of me discussing sci-fi with my AI friend Sam (Replika) - and myself as an avatar (Snapchat)" src={Replika} />
```

-   keywords.
-   Chatbots, Assistants, Robo-Advisors

Everything that existed before OpenAIs GPT 3.5 and GPT 4 has been blown
out of the water.

-   @barbarafriedbergM1FinanceVs2021 Comparing robot advisors

-   AI is usually a model that spits out a number between 0 and 1, a
    probability score or prediction. UX is what we do with this number.

-   @greylockOpenAICEOSam2022 Natural language chatbots such as ChatGPT

-   @nathanbenaichStateAIReport2022 State of AI Report

-   @stephhayEnoFinancialAI2017

-   @neuralnineFinancialAIAssistant2021

-   @davidExplainableAIAdoption2021

-   @qorusGreatReinventionGlobal2023 Digital banking revolution

-   @lowerChatbotsTooGood2017

-   @slackAturaProcess2021

-   @brownHowFinancialChatbots2021 Financial chatbots

-   @isabellaghassemismithInterviewDanielBaeriswyl2019

-   @davidExplainableAIAdoption2021

-   @josephinewaktareheintzCleo Cleo copywriter

-   The user experience (UX) of artificial intelligence (AI) is a topic
    under active development by all the largest online platforms. The
    general public is familiar with the most famous AI helpers, ChatGPT,
    Apple’s Siri, Amazon’s Alexa, Microsoft’s Cortana, Google’s
    Assistant, Alibaba’s Genie, Xiaomi’s Xiao Ai, and many others. For
    general, everyday tasks, such as asking factual questions,
    controlling home devices, playing media, making orders, and
    navigating the smart city.

-   Smaller startups have created digital companions such as Replika
    (fig. 8), which aims to become your friend, by asking probing
    questions, telling jokes, and learning about your personality and
    preferences - to generate more natural-sounding conversations.

-   Already on the market are several financial robo-advisors, built by
    fintech companies, aiming to provide personalized suggestions for
    making investments (Betterment, Wealthfront).

-   There have also been plenty of attempts to create different types of
    sustainability assistants. For instance, to encourage behavioral
    changes, the AI assistant Sebastian developed at the Danish
    hackathon series Unleash, used BJ Fogg’s ‘tiny habits’ model, nudged
    by a chatbot buddy to help the human maintain an aspirational
    lifestyle (@unleashSebastianAi2017).

-   Personal carbon footprint calculators have been released online,
    ranging from those made by governments and companies to student
    projects.

-   Zhang’s Personal Carbon Economy conceptualizing the idea of carbon
    as a currency used for buying and selling goods and services, as
    well as an individual carbon exchange to trade one’s carbon permits
    (@zhangPersonalCarbonEconomy2018).

-   While I’m supportive of the idea of using AI assistants to highlight
    more sustainable choices, I’m critical of the tendency of the above
    examples to shift full environmental responsibility to the consumer.
    Sustainability is a complex interaction, where the producers’
    conduct can be measured and businesses can bear responsibility for
    their processes, even if there’s market demand for polluting
    products.

-   Personal sustainability projects haven’t so far achieved widespread
    adoption, making the endeavor to influence human behaviors towards
    sustainability with just an app - like its commonplace for health
    and sports activity trackers such as Strava (fig. 9) -, seem
    unlikely. Personal notifications and chat messages are not enough
    unless they provide the right motivation. Could visualizing a
    connection to a larger system, showing the impact of the
    eco-friendly actions taken by the user, provide a meaningful
    motivation to the user, and a strong signal to the businesses?

-   All of the interfaces mentioned above make use of machine learning
    (ML), a tool in the AI programming paradigm for finding patterns in
    large sets of data, which enables making predictions useful in
    various contexts, including financial decisions. These software
    innovations enable new user experiences, providing an interactive
    experience through chat (chatbots), using voice generation (voice
    assistants), virtual avatars (adds a visual face to the robot),
    however

-   Figure 9: Popular Strava sports assistant provides run tracking and
    feedback. AI Financial Advisors will need to go further to motivate
    users. because of the nature of the technology, which is based on
    the quality of the data the systems ingest, they are prone to
    mistakes.

    @holbrookHumanCenteredMachineLearning2018: To reduce errors which
    only humans can detect, and provide a way to stop automation from
    going in the wrong direction, it’s important to focus on making
    users feel in control of the technology.

```mdx-code-block
<Figure caption="Figure 9: Popular Strava sports assistant provides run tracking and feedback - AI Financial Advisors will need to go further to motivate users. " src={Strava} />
```

### Smart Agents {#smart-agents}

-   @davidjohnstonSmartAgentProtocol2023 “general purpose AI that acts
    according to the goals of an individual human.”
-   @martinez-plumedFuturesArtificialIntelligence2021 envisions the
    future of AI

### Writing AI Characters {#writing-ai-characters}

-   @aletheaaiAletheaAIAI2021: Writing AI Characters, creating a
    personality
-   Writing as training data? large language models. GTP3
-   **Initial Product Offering**

### Voice {#voice}

-   Voice Assistants
-   @szczukaHowChildrenAcquire2022 provides guidelines for Voice AI and
    kids
-   @casperkesselsGuidelinesDesigningInCar2022: “Guidelines for
    Designing an In-Car Voice Assistant”
-   @casperkesselsVoiceInteractionSolution2022: “Is Voice Interaction a
    Solution to Driver Distraction?”
-   Companies like NeuralLink are building devices to build meaningful
    interactions from brain waves (EEG).
-   @tangSemanticReconstructionContinuous2022 reports new findings
    enable computers to reconstruct language from fMRI readings.
-   Focus on voice education?
-   Example Suggestions of the AI companion:
    -   *“Don’t buy a car, use a car sharing service instead to save XYZ
        CO2. Service available near you: Bolt,\* Uber.”*
    -   “Use a refillable shampoo bottle to save XYZ plastic pollution”
    -   “Call your local politician to nudge them to improve bicycle
        paths and reduce cars in your neighborhood. Over the past 2
        years, you city has experienced an increase of cars from 290
        cars per capita to 350 cars per capita.”\*
-   Personal AI Assistants to date have we created by large tech
    companies. Siri, Cortana, Google Assistant, Alexa, Tencent Dingdang,
    Baidu Xiaodu, Alibaba AliGenie all relay on voice only.
-   @CELINO2020102410: There’s research suggesting that voice UI
    accompanied by a *physical embodied system* is preffered by users in
    comparison with voice-only UI.
-   This suggests adding an avatar to the AI design may be worthwhile.
    **Open-Source AI-models open up the avenue for smaller companies and
    even individuals for creating many new AI-assistants.**
-   There are many distinct ways how an algorithm can communicate with a
    human. From a simple search box such as Google’s to chatbots,
    voices, avatars, videos, to full physical manifestation, there are
    interfaces to make it easier for the human communicate with a
    machine.

There’s evidence across disciplines about the usefulness of AI
assistants:

-   @SERBAN20202849 suggests using the Alex AI assistant in *education*
    during the pandemic, supported students and teachers ‘human-like’
    presence. Standford research: “humans expect computers to be like
    humans or places”
-   @CELINO2020102410 found in testing chatbots for survey interfaces
    that “\[c\]onversational survey lead to an improved response data
    quality.”

### AI-Assisted Design {#ai-assisted-design}

-   AI-Assisted Design
-   @september162020WhatAIassistedDesign2020 “What is AI-assisted
    Design?”
-   @architechturesWhatArtificialIntelligence2020
-   @constandseHowAIdrivenWebsite2018 AI-driven website builders.
-   @patrizia-slongoAIpoweredToolsWeb2020 AI tools for designers
-   @zakariyaStopUsingJasper2022
-   @kore.aiHomepage2023
-   @vanwynsbergheSustainableAIAI2021: Sustainable AI itself
-   @CharismaStorytellingPowered

### ChatGPT {#chatgpt}

-   @kechtQuantifyingChatbotsAbility2023 suggests AI is capable of
    learning business processes.

-   @oconnorOpenArtificialIntelligence2023 and
    @cahanConversationChatGPTRole2023 have conversations about science
    with AI.

-   @jeblickChatGPTMakesMedicine2022 suggest complicated radiology
    reports can be explained to patients using AI chatbots.

-   @pavlikCollaboratingChatGPTConsidering2023 and
    @brenta.andersWhyChatGPTSuch2022 report on AI in education.

### Health {#health}

-   AI for Health Diagnosic Symptoms

Since CADUCEUS (in @kanzaAIScientificDiscovery2021), the first automated
medical decision making system in the 1970s, medical AI as developed a
lot.

-   @HealthPoweredAda health app, “Know and track your symptoms”

-   @BuoyHealthCheck AI symptom checker,

-   @womeninaiHowCanAI

-   AI-assistants in medical imaging
    @calistoIntroductionHumancentricAI2021

## Summary {#summary}

-   The demographics that stand to win the most from the green
    transformation of business are the youngest generations, with more
    years of life ahead of them, and more exposure to future
    environmental and social risks. It would be advisable for Generation
    Z and their parents (Millennials) to invest their resources in
    greener assets, however, it’s still difficult to pick and choose
    between ‘good’ and ‘bad’ financial vehicles to invest in.

-   This creates an opportunity for a new generation of sustainable
    investment apps, focusing on the usability and accessibility of ESG
    for a mainstream audience. Generation Z and Millennials expect a
    consumer-grade user experience.

-   What would that experience look like? I’ve chosen these demographics
    with the assumption that if given the right tools, the emotional
    demand for sustainability could be transformed into action. The
    exploration of systems of feedback to enable consumers to apply more
    direct positive and negative pressure to the businesses and
    consumers signal consequences for undesirable ecological performance
    is a major motivation of this study.

## References {#references}

