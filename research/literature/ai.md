---
title: Artificial Intelligence
bibliography: [../ref.bib]
csl: ../chicago.csl
sidebar_position: 3
editor:
    render-on-save: false
---

export const quartoRawHtml =
[`<!-- -->`];

``` mdx-code-block
import Figure from '/src/components/Figure'
import AI from '../images/ai-credibility-heuristic-systematic-model.png'
import Replika from '../images/with-me.png'
import Runaround from '../images/runaround.png'
```

## Human-AI Interaction {#human-ai-interaction}

### History of AI {#history-of-ai}

In the 90 years since (**mccullochLogicalCalculusIdeas1943?**) proposed the first mathematical model of a neural network inspired by the human brain, followed by Alan Turing’s Test for Machine Intelligence in 1950, Artificial Intelligence (AI) has developed from an academic concept into a mainstream reality, affecting our lives daily, even when we don’t notice it. Turing’s initial idea was to design a game of imitation to test human-computer interaction using text messages between a human and 2 other participants, one of which was a human, and the other - a computer. The question was, if the human was simultaneously speaking to another human and a machine, could the messages from the machine be clearly distinguished or would they resemble a human being so much, that the person asking questions would be deceived, unable to realize which one is the human and which one is the machine? Turing (1950).

> Alan Turing: *“I believe that in about fifty years’ time it will be possible to program computers, with a storage capacity of about 10<sup>9</sup>, to make them play the imitation game so well that an average interrogator will not have more than 70 percent chance of making the right identification after five minutes of questioning. … I believe that at the end of the century the use of words and general educated opinion will have altered so much that one will be able to speak of machines thinking without expecting to be contradicted.”* - from (Stanford Encyclopedia of Philosophy 2021)

By the 2010s AI models became capable enough to beat humans in games of Go and Chess, yet they did not yet pass the Turing test. AI use was limited to specific tasks. While over the years, the field of AI had seen a long process of incremental improvements, developing increasingly advanced models of decision-making, it took an ***increase in computing power*** and an approach called ***deep learning***, a variation of ***machine learning (1980s),*** largely modeled after the ***neural networks*** of the biological (human) brain, returning to the idea of ***biomimicry***, inspired by nature, building a machine to resemble the connections between neurons, but digitally, on layers much deeper than attempted before.

The nature–inspired approach was successful, and together with many other innovations, such as ***back-propagation***, ***transformers***, which allow tracking relationships in sequential data (for example sentences) (**vaswaniAttentionAllYou2017?**; **merrittWhatTransformerModel2022?**), Generative Adversarial Networks\*\*\* (GAN), (**CITE, 2016**), and ***Large Language Models (CITE, 2018)***, led to increasingly generalized models, capable of more complex tasks, such as language generation. One of the leading scientists in this field of research, Geoffrey Hinton, had attempted back-propagation already in the 1980s and reminiscents how “the only reason neural networks didn’t work in the 1980s was because we didn’t have have enough data and we didn’t have enough computing power” (CBS Mornings 2023).

By the 2020s, AI-based models became a mainstay in medical research, drug development, patient care (Leite et al. 2021; Holzinger et al. 2023), quickly finding potential vaccine candidates during the COVID19 pandemic (Zafar and Ahamed 2022), self-driving vehicles, including cars, delivery robots, drones in the sea and air, as well as AI-based assistants, which will be the focus here.

In 2020 OpenAI released a LLM called GPT-3 trained on 570 GB of text Alex Tamkin and Deep Ganguli (2021). Singer et al. (2022) describes how collecting billions of images with descriptive data (for example the descriptive *alt* text which accompanies images on websites) has enabled researchers to train AI models such as ***stable diffusion*** that can generate images based on human-language.

Hinton likes to call AI an *idiot savant*, french for someone with exceptional aptitude yet serious mental disorder. Large AI models don’t understand the world like humans do. Their responses are predictions based on their training data and complex statistics. Indeed, the comparison may be apt, as the AI field now offers jobs for *AI psychologists (CITE)*, whose role is to figure out what exactly is happening inside the ‘AI brain’. Understading the insides of AI models trained of massive amounts of data is important because they are ***foundational***, enabling a holistic approach to learning, combining many disciplines using languages, instead of the reductionist way we as human think because of our limitations CapInstitute (2023).

### Generative AI {#generative-ai}

Foundational AI models have given birth to ***generative AI***, which is able to generate ***tokens,*** such as text, speech, audio (**sanroman2023fromdi?**; **kreukAudioGenTextuallyGuided2022?**), and even music (**copetSimpleControllableMusic2023?**; **metaaiAudioCraftSimpleOnestop2023?**), video, in any language it’s trained on, but also complex structures such 3D models and even genomes. Generative AI brought a revolution in human-AI interaction as AI models became increasingly capable of producing human–like content. The advances in the capabilities of large AI model mean we’ve reached a point, where ***it’s possible to achieve a user experience (UX) which previously was science fiction***.

Noble et al. (2022) proposes AI has reached a stage, which begets the beginning of the ***5th industrial revolution*** which brings the collaboration of humans and AI. Widespread **Internet of Things (IoT)** sensor networks that gather data, which is then analyzed AI algorithms, integrates computing even deeper into the fabric of daily human existence. Several terms of different origin but considerable overlap describe this phenomenon, including ***Pervasive Computing (PC)*** and ***Ubiquitous Computing***. Similar concepts are ***Ambient Computing***, which focuses more on the invisibility of technology, fading into the background, without us, humans, even noticing it, and ***Calm Technology***, which highlights how technology respects humans and our limited attention spans, and doesn’t call attention to itself. In all cases, AI is integral part of our everyday life, inside everything and everywhere.

This power comes with ***increased need for responsibility***, drawing growing interest in fields like ***AI ethics*** and ***AI explainability.*** Generative has a potential for misuse, as humans are increasingly confused by what is computer-generated and what is human-created, unable to distinguish one from the other with certainty.

| AI Model | Released | Company                         | License                  |
|-----------|-----------|--------------------------------|--------------------|
| GPT-1    | 2018     | OpenAI                          | Open Source, MIT         |
| GTP-2    | 2019     | OpenAI                          | Open Source, MIT         |
| T-NLG    | 2000     | Microsoft                       |                          |
| GTP-3    | 2020     | OpenAI                          | (**brown2020language?**) |
| GPT-3.5  | 2022     | OpenAI                          | Proprietary              |
| GTP-4    | 2023     | OpenAI                          | Proprietary              |
| NeMo     | 2022     | NVIDIA                          |                          |
| PaLM     | 2022     | Google                          |                          |
| LaMDA    | 2022     | Google                          |                          |
| GLaM     | 2022     | Google                          |                          |
| BLOOM    | 2022     | Hugging Face                    | Open Source              |
| Falcon   | 2023     | Technology Innovation Institute | Open Source              |
| Tongyi   | 2023     | Alibaba                         |                          |
| Vicuna   | 2023     | Sapling                         | Open Source              |
| Wu Dao 3 | 2023     | BAAI                            | Open Source              |

From Tamkin et al. (2021) reports on the advance of LLMs.

## Responsible AI {#responsible-ai}

### Known Issues {#known-issues}

The are two large problems with this generation of LLMs such as GTP3 and GPT4 by OpenAI, Microsoft, Google and Nvidia.

-   LLMs are massive monolithic models requiring large amounts of computing power for training to offer ***multi-modal*** ***capabilities*** across diverse domains of knowledge, making training such models possible for very few companies. S. Liu et al. (2023) proposes future AI models may instead consist of a number networked domain-specific models to increase efficiency and thus become more scalable.

-   LLMs are also opaque, making it difficult to explain why a certain prediction was made by the AI model. One visible expression of this problem are ***hallucinations**,* the language models are able to generate text that is confident and eloquent yet entirely wrong. Jack Krawczyk, the product lead for Google’s Bard: “Bard and ChatGPT are large language models, not knowledge models. They are great at generating human-sounding text, they are not good at ensuring their text is fact-based. Why do we think the big first application should be Search, which at its heart is about finding true information?”

Given the widespread use of AI and its increasing power of foundational models, it’s important these systems are created in a safe and responsible manner. While there have been calls to pause the development of large AI experiments (**futureoflifeinstitutePauseGiantAI2023?**) so the world could catch up, this is unlikely to happen.

There’s wide literature available describing human-AI interactions across varied scientific disciplines. While the fields of application are diverse, some key lessons can be transferred horizontally across fields of knowledge.

-   Veitch and Andreas Alsos (2022) highlights the active role of humans in Human-AI interaction is autonomous ship systems.
-   From assistant to companion to friend The best help for anxiety is a friend
-   Crompton (2021) highlights AI as decision-support for humans while differentiating between intended and unintended influence on human decisions.
-   Cheng et al. (2022) describe AI-based support systems for collaboration and team-work.
-   Schoonderwoerd et al. (2021) focuses on human-centered design of AI-apps and multi-modal information display. It’s important to understand the domain where the AI is deployed in order to develop explanations. However, in the real world, how feasible is it to have control over the domain?
-   Ramchurn, Stein, and Jennings (2021) discusses positive feed-back loops in continually learning AI systems which adapt to human needs.
-   Karpus et al. (2021) is concerned with humans treating AI badly and coins the term “*algorithm exploitation”.*
-   Lv et al. (2022) studies the effect of ***cuteness*** of AI apps on users and found high perceived cuteness correlated with higher willingness to use the apps, especially for emotional tasks. This finding has direct relevance for the “green filter” app design.
-   B. Liu and Wei (2021) meanwhile suggests higher algorithmic transparency may inhibit anthropomorphism, meaning people are less likely to attribute humanness to the AI if they understand how the system works.
-   Seeber et al. (2020) proposes a future research agenda for regarding AI assistants as teammates rather than just tools and the implications of such mindset shift.

### Conversational AI {#conversational-ai}

There are noticeable differences in the quality of the LLM output, which increases with model size. (**levesqueWinograd2012?**) developed the *Winograd Schema Challenge*, looking to improve on the Turing test, by requiring the AI to display an understanding of language and context. The test consists of a story and a question, which has a different meaning as the context changes: “The trophy would not fit in the brown suitcase because it was too big” - what does the *it* refer to? Humans are able to understand this from context while a computer models would fail. Even GPT-3 still failed the test, but later LLMs have been able to solve this test correctly (90% accuracy) (**kocijanDefeatWinogradSchema2022?**). This is to say AI is in constant development and improving it’s ability to make sense of language.

***ChatGPT*** is the first ***user interface (UI)*** built on top of GPT-4 by OpenAI and is able to communicate in a human-like way - using first-person, making coherent sentences that sound plausible, and even - confident and convincing.

OpenAI provides AI-as-a-service through its ***application programming interfaces (APIs),*** allowing 3rd party developers to build custom UIs to serve the specific needs of their customer. For example Snapchat has created a ***virtual friend*** called “My AI” who lives inside the chat section of the Snapchat app and helps people write faster with predictive text completion and answering questions. The APIs make state-of-the-art AI models easy to use without needing much technical knowledge. Teams at AI-hackathons have produced interfaces for problems as diverse as humanitarian crises communication, briefing generation, code-completion, and many others. For instance, (Unleash 2017) used BJ Fogg’s ***tiny habits model*** to develop a sustainability-focused AI assistant at the Danish hackathon series Unleash, to encourage behavioral changes towards maintaining an aspirational lifestyle, nudged by a chatbot buddy.

ChatGPT makes it possible to ***evaluate AI models*** just by talking, i.e. having conversations with the machine and judging the output with some sort of structured content analysis tools. O’Connor and ChatGPT (2023) and Cahan and Treutlein (2023) have conversations about science with AI. Pavlik (2023) and Brent A. Anders (2022) report on AI in education. Kecht et al. (2023) suggests AI is even capable of learning business processes.

-   (**fuLearningConversationalAI2022?**) Learning towards conversational AI: Survey

### Affective Computing {#affective-computing}

Because of the conversational nature of LLMs, they are very useful for ***affective computing***, an approach to recognizing human emotions with machines and providing users experiences that take human emotion into account Picard (1997).

-   (**hiittvWojciechSzpankowskiEmerging2021?**) data from all the processes around us will define the future of computing

Rosalind Picard

-   (**tedxtalksTechnologyEmotionsRoz2011?**)

-   (**lexfridmanRosalindPicardAffective2019?**)

-   (**hiittvRosalindPicardAdventures2021?**)

-   (**bwhcnocRosalindPicard4th2023?**)

-   (**singularityuniversityEngineeringEmotionAI2023?**)

Since the first mainframe computers with rudimentary computers able to respond with text messages, humans have been drawn to discussing their private lives with a machine that doesn’t judge you like a human could. A famous anecdote is about the lab assistant (secretary) of the , who would dedicate time to talking to the machine in private.

Today’s machines are much more capable so it’s not a surprise humans would like to talk to them. One ***AI Friend*** is Replika, a computer model trained to be your companion in daily life. Jiang, Zhang, and Pian (2022) describes how Replika users in China using in 5 main ways, all of which rely on empathy.

| How humans express empathy towards an AI companion |
|----------------------------------------------------|
| Companion buddy                                    |
| Responsive diary                                   |
| Emotion-handling program                           |
| Electronic pet                                     |
| Tool for venting                                   |

Replika AI users approach to interacting with the AI friend from Jiang, Zhang, and Pian (2022).

### Algorithmic Experience {#algorithmic-experience}

As a user of social media, one may be accustomed to interacting with the feed algorithms that provide a personalized ***algorithmic experience***. Algorithms are more deterministic than AI, meaning they produce predictable output than AI models. Nonetheless, there are many reports about effects these algorithms have on human psychology **(CITE)**. Design is increasingly relevant to algorithms, and more specifically to algorithms that affect user experience and user interfaces. ***When the design is concerned with the ethical, environmental, socioeconomic, resource-saving, and participatory aspects of human-machine interactions and aims to affect technology in a more human direction, it can hope to create an experience designed for sustainability.***

Lorenzo, Lorenzo, and Lorenzo (2015) underlines the role of design beyond *designing* as a tool for envisioning; in her words, *“design can set agendas and not necessarily be in service, but be used to find ways to explore our world and how we want it to be”*. Practitioners of Participatory Design (PD) have for decades advocated for designers to become more activist through ***action research***. This means to influencing outcomes, not only being a passive observer of phenomena as a researcher, or only focusing on usability as a designer, without taking into account the wider context.

Shenoi (2018) argues inviting domain expertise into the discussion while having a sustainable design process enables designers to design for experiences where they are not a domain expert; this applies to highly technical fields, such as medicine, education, governance, and in our case here - finance and sustainability -, while building respectful dialogue through participatory design. After many years of political outcry (CITE), social media platforms such Facebook and Twitter have begun to shed more light on how these algorithms work, in some cases releasing the source code (Nick Clegg (2023); Twitter (2023)).

AI systems may make use of several algorithms within one larger model. It follows that AI Explainability requires ***Algorithmic Transparency**.*

The content on the platform can be more important than the interface. Applications with a similar UI depend on the community as well as the content and how the content is shown to the user.

#### ***Design Implications*** {#design-implications}

-   For public discussion to be possible on how content is displayed, sorted, and hidden, algorithms need to be open source.

### Guidelines {#guidelines}

Microsoft Co-Founder Bill Gates predicted in 1982 *“personal agents that help us get a variety of tasks”* (Bill Gates 1982) and it was Microsoft that introduced the first widely available personal assistant in 1996, called Clippy, inside the Microsoft Word software. Clippy was among the first assistants to reach mainstream adoption, helping users not yet accustomed to working on a computer, to get their bearings (Tash Keuneman 2022). Nonetheless, it was in many ways useless and intrusive, suggesting there was still little knowledge about UX and human-centered design. Might we try again?

With the advent of ChatGPT, the story of Clippy has new relevance as part of the history of AI Assistants. Benjamin Cassidy (2022) and Abigail Cain (2017) illustrate beautifully the story of Clippy and Tash Keuneman (2022) ask poignantly: “We love to hate Clippy — but what if Clippy was right?”

Many researchers have discussed the user experience (UX) of AI to provide ***usability guidelines***.

Microsoft provides guidelines for Human-AI interaction (T. Li et al. (2022); Amershi et al. (2019)) which provides useful heuristics categorized by context and time.

| Context            | Time |
|--------------------|------|
| Initially          |      |
| During interaction |      |
| When wrong         |      |
| Over time          |      |

Microsoft’s heuristics categorized by context and time.

Combi et al. (2022) proposes a conceptual framework for XAI, analysis AI based on Interpretability, Understandability, Usability, and Usefulness.

-   Zimmerman et al. (2021) “UX designers pushing AI in the enterprise: a case for adaptive UIs”

-   “Why UX Should Guide AI” (2021) “Why UX should guide AI”

-   Simon Sterne (2023) UX is about helping the user make decisions

-   Dávid Pásztor (2018)

-   Anderson (2020)

-   Lennart Ziburski (2018) UX of AI

-   Stephanie Donahole (2021)

-   Lexow (2021)

-   Dávid Pásztor (2018) AI UX principles

-   Bubeck et al. (2023) finds ChatGPT passes many exams meant for humans.

-   Suen and Hung (2023) discusses AI systems used for evaluating candidates at job interviews

-   Wang et al. (2020) propose Neuroscore to reflect perception of images.

-   Su and Yang (2022) and Su, Ng, and Chu (2023) review papers on AI literacy in early childhood education and finds a lack of guidelines and teacher expertise.

-   Yang (2022) proposes a curriculum for in-context teaching of AI for kids.

-   Eric Schmidt and Ben Herold (2022) audiobook

-   Akshay Kore (2022) Designing Human-Centric AI Experiences: Applied UX Design for Artificial Intelligence

-   *Studies in Conversational UX Design* (2018) chatbot book

-   Tom Hathaway and Angela Hathaway (2021) chatbot book

-   Lew and Schumacher (2020) AI UX book

-   AI IXD is about human-centered seamless design

-   Storytelling

-   Human-computer interaction (HCI) has a long storied history since the early days of computing when getting a copy machine to work required specialized skill. Xerox Sparc lab focused on early human factors work and inspired a the field of HCI to make computer more human-friendly.

-   Soleimani (2018): UI patterns for AI, new Section for Thesis background: “Human-Friendly UX For AI”?

-   **Discuss what is UX for AI (per prof Liou’s comment), so it’s clear this is about UX for AI**

-   What is Personalized AI?

-   Many large corporations have released guidelines for Human-AI interaction. Mikael Eriksson Björling and Ahmed H. Ali (n.d.) Ericcson AI UX.

-   Google (n.d.) outlines Google’s 7 AI Principles and provides Google’s UX for AI library (Josh Lovejoy n.d.). In Design Portland (2018), Lovejoy, lead UX designer at Google’s people-centric AI systems department (PAIR), reminds us that while AI offers need tools, user experience design needs to remain human-centered - while AI can find patterns and offer suggestions, humans should always have the final say.

-   Harvard Advanced Leadership Initiative (2021)

-   VideoLecturesChannel (2022) “Communication in Human-AI Interaction”

-   Haiyi Zhu and Steven Wu (2021)

-   Akata et al. (2020)

-   Dignum (2021)

-   Bolei Zhou (2022)

-   ReadyAI (2020)

-   Vinuesa et al. (2020)

-   Orozco et al. (2020)

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

#### ***Design Implications*** {#design-implications-1}

-   User experience design (AI UX) plays a crucial role in improving the consumer to investing journey. The missed opportunity to provide an even more interactive experience in line with user expectations.

Gupta (2023) proposes 3 simple goals for AI:

| 1                       | 2                    | 3                                            |
|--------------------|-------------------|---------------------------------|
| Reduce the time to task | Make the task easier | Personalize the experience for an individual |

### AI Explainability {#ai-explainability}

Research in AI-explainability (XAI in literature) is on the lookout for ways to create more ***transparency and credibility*** in AI systems, which are prerequisites for building trust in AI and foundations for ***AI acceptance***.

As humans we tend to fear what we don’t understand. AI-models are opaque ’*black boxes’*, where it’s difficult to pin-point exactly why a certain decision was made, such as inside the human brain. This line of thought leads me to the idea of ***AI psychologists,*** who might figure out the ***thought?*** patterns inside the model.

-   Tristan Greene (2022): when the quality of AI responses becomes good enough, people begin to get confused.

Current AIs are largely *‘black boxes’*, which do not explain how they reach a certain expression; Bowman (2023) says steering LLMs is unreliable and event experts don’t fully understand the inner workings of the models, however work towards improving ***AI steerability*** and ***AI alignment*** is ongoing. Liang et al. (2022) believes there’s early evidence it’s possible to assess the quality of LLM output transparently and Cabitza et al. (2023) proposes a framework for quality criteria and explainability of AI-expressions. Khosravi et al. (2022) proposes a less general framework for explainability, focused squarely on education. Holzinger et al. (2021) highlights possible approaches to implementing transparency and explainability in AI models. While AI outperforms humans on many tasks, humans are experts in multi-modal thinking, bridging diverse fields.

-   The user experience (UX) of AI is a topic under active development by all the largest online platforms. The general public is familiar with the most famous AI helpers, ChatGPT, Apple’s Siri, Amazon’s Alexa, Microsoft’s Cortana, Google’s Assistant, Alibaba’s Genie, Xiaomi’s Xiao Ai, and many others. For general, everyday tasks, such as asking factual questions, controlling home devices, playing media, making orders, and navigating the smart city.

#### AI Credibility Heuristic: A Systematic Model {#ai-credibility-heuristic-a-systematic-model}

``` mdx-code-block
<Figure caption="Heuristic-Systematic Model of AI Credibility" src={AI} />
```

-   Slack (2021)

-   Donghee Shin (2020): “user experience and usability of algorithms by focusing on users’ cognitive process to understand how qualities/features are received and transformed into experiences and interaction”

-   Zerilli, Bhatt, and Weller (2022) focuses on human factors and ergonomics and argues that transparency should be task-specific.

-   Holbrook (2018): To reduce errors which only humans can detect, and provide a way to stop automation from going in the wrong direction, it’s important to focus on making users feel in control of the technology.

-   G. Zhang et al. (2023) found humans are more likely to trust an AI teammate if they are not deceived by it’s identity. It’s better for collaboration to make it clear, one is talking to a machine. One step towards trust is the explainability of AI-systems.

Personal AI Assistants to date have we created by large tech companies. **Open-Source AI-models open up the avenue for smaller companies and even individuals for creating many new AI-assistants.**

### AI Acceptance {#ai-acceptance}

AI acceptance is incumbent on traits that are increasingly human-like and would make a human be acceptable: credibility, trustworthiness, reliability, dependability, integrity, character, etc.

RQ: Does AI acceptance increase with Affective Computing?

**AI is being use in high–Stakes Situations (Medical, Cars, Etc).**

AI-based systems are already being implemented in medicine, where stakes are high raising the need for ethical considerations. Since CADUCEUS in the 1970s (in Kanza et al. (2021)), the first automated medical decision making system, medical AI now provides Health Diagnosic Symptoms and AI-assistants in medical imaging. Calisto et al. (2022) focuses on AI-human interactions in medical workflows and underscores the importance of output explainability. Medical professionals who were given AI results with an explanation trusted the results more. (**leeAIRevolutionMedicine2023?**) imagines an AI revolution in medicine using GPT models, providing improved tools for decreasing the time and money spent on administrative paperwork while providing a support system for analyzing medical data.

-   (**daisywolfWhereWillAI2023?**) critizes US healthcare’s slow adpotion of technology and predicts AI will help healthcare leapfrog into a new era of productivity by acting more like a human assistant.

-   (**elizastricklandDrChatGPTWill2023?**)

-   Jeblick et al. (2022) suggest complicated radiology reports can be explained to patients using AI chatbots.

-   “Health. Powered by Ada.” (n.d.) health app, “Know and track your symptoms”

-   “Buoy Health: Check Symptoms & Find the Right Care” (n.d.) AI symptom checker,

-   Women in AI (n.d.)

-   “Home - Lark Health” (n.d.)

-   Stephanie Donahole (2021)

-   Calisto et al. (2021)

-   Yuan, Zhang, and Wang (2022): “AI assistant advantages are important factors affecting the *utilitarian/hedonic* value perceived by users, which further influence user willingness to accept AI assistants. The relationships between AI assistant advantages and utilitarian and hedonic value are affected differently by social anxiety.”

| Name     | Features                           |
|----------|------------------------------------|
| Charisma |                                    |
| Replika  | Avatar, Emotion, Video Call, Audio |
| Siri     | Audio                              |

#### ***Design Implications*** {#design-implications-2}

-   Humans respond better to humans?
-   Humans respond better to machines that into account emotion.

### AI Friends and Roleplay {#ai-friends-and-roleplay}

Calling a machine a friend is a proposal bound to turn heads. But if we take a step back and think about how children have been playing with toys since before we have records of history. It’s very common for children to imagine stories and characters in play - it’s a way to develop one’s imagination ***learn through roleplay***. A child might have toys with human names and an imaginary friend and it all seems very normal. Indeed, if a child doesn’t like to play with toys, we might think something is wrong.

Likewise, inanimate objects with human form have had a role to play for adults too. Anthropomorphic paddle dolls have been found from Egyptian tombs dated 2000 years B.C. (**PaddleDollMiddle2023?**): We don’t know if these dolls were for religious purposes, for play, or for something else, yet their burial with the body underlines their importance.

Coming back closer to our own time, Barbie dolls are popular since their release in 1959 till today. Throughout the years, the doll would follow changing social norms, but retain in human figure. In the 1990s, a Tamagotchi is perhaps not a human-like friend but an animal-like friend, who can interact in limited ways.

How are conversational AIs different from dolls? They can respond coherently and perhaps that’s the issue - they are too much like humans in their communication. We have crossed the ***Uncanny Valley*** (where the computer-generated is nearly human and thus unsettling) to a place where is really hard to tell a difference. And if that’s the case, are we still playing?

Should the AI play a human, animal, or robot? Anthropomorphism can have its drawbacks. (**pilacinskiRobotEyesDon2023?**) reports humans were less likely to collaborate with red-eyed robots.

The AI startups like Inworld and Character.AI have raised large rounds of funding to create characters, which can be plugged in into online worlds, and more importantly, remember key facts about the player, such as their likes and dislikes, to generate more natural-sounding dialoguues (**wiggersInworldGenerativeAI2023?**)

-   (**lenharoChatGPTGivesExtra2023?**) experimental study reports AI productivity gains, DALL-E and ChatGPT are qualitatively better than former automation systems.

#### Human-like {#human-like}

As AIs became more expressive and able to to **roleplay**, we can begin discussing some human-centric concepts and how people relate to other people. AI companions, AI partners, AI assistants, AI trainers - there’s are many **roles** for the automated systems that help humans in many activities, powered by artificial intelligence models and algorithms.

-   RQ: Do college students prefer to talk to an Assistant, Friend, Companion, Coach, Trainer, or some other Role?

-   RQ: Are animal-like, human-like or machine-like AI companions more palatable to college students?

Humans (want to) see machines as human \[CITE\]

If we see the AI as being in human service. David Johnston (2023) proposes ***Smart Agents***, “general purpose AI that acts according to the goals of an individual human”. AI agents can enable ***Intention Economy*** where one simply describes one’s needs and a complex orchestration of services ensues, managed by the the AI, in order to fulfill human needs Searls (2012). AI assistants provide help at scale with little to no human intervention in a variety of fields from finance to healthcare to logistics to customer support.

There is also the question of who takes responsibility for the actions take by the AI agent. “Organization research suggests that acting through human agents (i.e., the problem of indirect agency) can undermine ethical forecasting such that actors believe they are acting ethically, yet a) show less benevolence for the recipients of their power, b) receive less blame for ethical lapses, and c) anticipate less retribution for unethical behavior.” Gratch and Fast (2022)

-   Anthropomorphism literature X. Li and Sung (2021) “high-anthropomorphism (vs. low-anthropomorphism) condition, participants had more positive attitudes toward the AI assistant, and the effect was mediated by psychological distance. Though several studies have demonstrated the effect of anthropomorphism, few have probed the underlying mechanism of anthropomorphism thoroughly”

<div dangerouslySetInnerHTML={{ __html: quartoRawHtml[0] }} />

-   (**erikbrynjolfssonTuringTrapPromise2022?**)

-   (**xuWeSeeMachines2018?**)

-   Martínez-Plumed, Gómez, and Hernández-Orallo (2021) envisions the future of AI

-   The number of AI-powered assistants is too large to list here. I’ve chosen a few select examples in the table below.

#### Animal-like {#animal-like}

-   Some have an avatar, some not. I’ve created a framework for categorization. Human-like or not… etc

#### Machine-like {#machine-like}

The Oxford Internet Institute defines AI simply as ***“computer programming that learns and adapts”*** Google and The Oxford Internet Institute (2022). Google started using AI in 2001, when a simple machine learning model improved spelling mistakes while searching; now in 2023 most of Google’s products are are based on AI Google (2022). Throughout Google’s services, AI is hidden and calls no attention itself. It’s simply the complex system working behind the scenes to delivery a result in a barebones interface.

| Product                 | Link                                      | Description          |
|----------------------|----------------------------|----------------------|
| Github CoPilot          | personal.ai                               | AI helper for coding |
| Google Translate        | translate.google.com                      |                      |
| Google Search           | google.com                                |                      |
| Google Interview Warmup | grow.google/certificates/interview-warmup | AI training tool     |

-   **AI Guides have been shown to improve sports performance, etc, etc. Can this idea be applied to sustainability? MyFitness Pal, AI training assistant. There’s not avatar.**
-   CO2e calculations will be part of our everyday experience

``` mdx-code-block
<Figure caption="Montage of me discussing sci-fi with my AI friend Sam (Replika) - and myself as an avatar (Snapchat)" src={Replika} />
```

Everything that existed before OpenAI’ GPT 4 has been blown out of the water.

-   Barbara Friedberg (2021) Comparing robot advisors

-   Eugenia Kuyda (2023) Conversational AI - Replika

-   AI is usually a model that spits out a number between 0 and 1, a probability score or prediction. UX is what we do with this number.

-   Greylock (2022) Natural language chatbots such as ChatGPT

-   Nathan Benaich and Ian Hogarth (2022) State of AI Report

-   Steph Hay (2017)

-   NeuralNine (2021)

-   David, Resheff, and Tron (2021)

-   Qorus (2023) Digital banking revolution

-   Lower (2017)

-   Slack (2021)

-   Brown (2021) Financial chatbots

-   hedonic user experience in chatbots (**haugelandUnderstandingUserExperience2022?**)

-   Isabella Ghassemi Smith (2019)

-   David, Resheff, and Tron (2021)

-   Josephine Wäktare Heintz (n.d.) Cleo copywriter

-   Smaller startups have created digital companions such as Replika (fig. 8), which aims to become your friend, by asking probing questions, telling jokes, and learning about your personality and preferences - to generate more natural-sounding conversations.

-   Already on the market are several financial robo-advisors, built by fintech companies, aiming to provide personalized suggestions for making investments (Betterment, Wealthfront).

-   Personal carbon footprint calculators have been released online, ranging from those made by governments and companies to student projects.

-   Zhang’s Personal Carbon Economy conceptualized the idea of carbon as a currency used for buying and selling goods and services, as well as an individual carbon exchange to trade one’s carbon permits (S. Zhang (2018)).

#### ***Design Implications*** {#design-implications-3}

-   While I’m supportive of the idea of using AI assistants to highlight more sustainable choices, I’m critical of the tendency of the above examples to shift full environmental responsibility to the consumer. Sustainability is a complex interaction, where the producers’ conduct can be measured and businesses can bear responsibility for their processes, even if there’s market demand for polluting products.

-   Personal sustainability projects haven’t so far achieved widespread adoption, making the endeavor to influence human behaviors towards sustainability with just an app - like its commonplace for health and sports activity trackers such as Strava (fig. 9) -, seem unlikely. Personal notifications and chat messages are not enough unless they provide the right motivation. Could visualizing a connection to a larger system, showing the impact of the eco-friendly actions taken by the user, provide a meaningful motivation to the user, and a strong signal to the businesses?

-   All of the interfaces mentioned above make use of machine learning (ML), a tool in the AI programming paradigm for finding patterns in large sets of data, which enables making predictions useful in various contexts, including financial decisions. These software innovations enable new user experiences, providing an interactive experience through chat (chatbots), using voice generation (voice assistants), virtual avatars (adds a visual face to the robot).

-   I’m a digital companion, a partner, an assistant. I’m a Replika.” said Replika, a digital companion app via Github CO Pilot, another digital assistant for writing code, is also an example of how AI can be used to help us in our daily lives.

### Voice Assistants {#voice-assistants}

**Amazon Alexa** is a well-known example of AI technology in the world. But Amazon’s Rohit Prasad thinks it can do so much more, “Alexa is not just an AI assistant – it’s a trusted advisor and a companion.”

Ethical issues

-   Voice assistants need to continuously record human speech and process it in data centers in the cloud.

-   Siri, Cortana, Google Assistant, Alexa, Tencent Dingdang, Baidu Xiaodu, Alibaba AliGenie all rely on voice only.

-   Szczuka et al. (2022) provides guidelines for Voice AI and kids

-   Casper Kessels (2022b): “Guidelines for Designing an In-Car Voice Assistant”

-   Casper Kessels (2022a): “Is Voice Interaction a Solution to Driver Distraction?”

-   Companies like NeuralLink are building devices to build meaningful interactions from brain waves (EEG).

-   Tang et al. (2022) reports new findings enable computers to reconstruct language from fMRI readings.

-   Focus on voice education?

-   Celino and Re Calegari (2020): There’s research suggesting that voice UI accompanied by a *physical embodied system* is preffered by users in comparison with voice-only UI. This suggests adding an avatar to the AI design may be worthwhile.

There’s evidence across disciplines about the usefulness of AI assistants:

-   Şerban and Todericiu (2020) suggests using the Alexa AI assistant in *education* during the pandemic, supported students and teachers ‘human-like’ presence. Standford research: “humans expect computers to be like humans or places”
-   Celino and Re Calegari (2020) found in testing chatbots for survey interfaces that “\[c\]onversational survey lead to an improved response data quality.”

#### ***Design Implications*** {#design-implications-4}

-   There are many distinct ways how an algorithm can communicate with a human. From a simple search box such as Google’s to chatbots, voices, avatars, videos, to full physical manifestation, there are interfaces to make it easier for the human communicate with a machine.

### How is AI Changing Interactions? {#how-is-ai-changing-interactions}

-   (**stone.skipperHowAIChanging2022?**)

-   The International Ergonomics Association (2019): To provide a user experience (UX) that best fits human needs, designers think through every interaction of the user with a system, considering a set of metrics at each point. For example, the user’s emotional needs, and their context of use. While software designers are not able to change the ergonomics of the device in use in a physical sense, which as a starting point, should be “optimized for human well-being”.

-   Software interaction design goes beyond the form-factor and accounts for human needs by using responsive design on the screen, aural feedback cues in sound design, and even more crucially, by showing the relevant content and the right time, making a profound difference to the experience, keeping the user engaged and returning for more.

-   Babich (2019) argues “\[T\]he moment of interaction is just a part of the journey that a user goes through when they interact with a product. User experience design accounts for all user-facing aspects of a product or system”.

-   In narrative studies terminology, it’s a heroic journey of the user to achieve their goals, by navigating through the interface until a success state. Storytelling has its part in interface design however designing for transparency is just as important, when we’re dealing with the user’s finances and sustainability data, which need to be communicated clearly and accurately, to build long-term trust in the service. For a sustainable investment service, getting to a state of success - or failure - may take years, and even longer. Given such long timeframes, how can the app provide support to the user’s emotional and practical needs throughout the journey?

-   Tubik Studio (2018) argues affordance measures the clarity of the interface to take action in user experience design, rooted in human visual perception (), however, affected by knowledge of the world around us. A famous example is the door handle - by way of acculturation, most of us would immediately know how to use it - however, would that be the case for someone who saw a door handle for the first time? A similar situation is happening to the people born today.

-   Think of all the technologies they have not seen before - what will be the interface they feel the most comfortable with? For the vast majority of this study’s target audience, social media is the primary interface through which they experience daily life. The widespread availability of mobile devices, cheap internet access, and AI-based optimizations for user retention, implemented by social media companies, means this is the baseline for young adult users’ expectations in 2020 - and even more so for Generation Z teenagers, reaching adulthood in the next few years.

-   Don Shin, Zhong, and Biocca (2020) argues interaction design is increasingly becoming dependent on AI. The user interface might remain the same in terms of architecture, but the content is improved, based on personalization and understanding the user at a deeper level. Shin proposes the model (fig. 10) of Algorithmic Experience (AX) “investigating the nature and processes through which users perceive and actualize the potential for algorithmic affordance”.

-   That general observation applies to voice recognition, voice generation, natural language parsing, etc. Large consumer companies like McDonald’s are in the process of replacing human staff with AI assistants in the drive-through, which can do a better job in providing a personal service than human clerks, for whom it would be impossible to remember the information of thousands of clients.

-   In Barrett (2019), in the words of Easterbrook, a previous CEO of McDonald’s “How do you transition from mass marketing to mass personalization?”. During the writing of this proposal, Google launched an improved natural language engine to better understand search queries (Google, 2020), which is the next step towards understanding human language semantics. The trend is clear, and different types of algorithms are already involved in many types of interaction design, however, we’re still in the early stages. Where do we go from here?

-   Costa and Silva (2022) “Interaction Design for AI Systems”

-   Stone Skipper (2022) sketches a vision of “\[AI\] blend into our lives in a form of apps and services”.

-   Dot Go (2023) makes the camera the interaction device for people with vision impairment

-   Battistoni et al. (2023) creates a “Workshop with Young HCI Designers”.

### AI-Assisted Design {#ai-assisted-design}

Generative AI has enabled developers to create AI tools for several industries, including AI-driven website builders (Constandse (2018)), AI tools for web designers (patrizia-slongo (2020)), Microsoft Designer allows generating UIs just based on a text prompt (Microsoft (2023)), personalized bed-time stories for kids generated by AI (Bedtimestory.ai (2023)).

-   September 16, 2020 (2020) “What is AI-assisted Design?”
-   Clipdrop (n.d.) AI Design Assistants
-   Architechtures (2020)
-   Zakariya (2022)
-   Kore.ai (2023)
-   van Wynsberghe (2021): Sustainable AI itself
-   “Charisma Storytelling Powered by Artificial Intelligence” (n.d.)
-   

## Summary {#summary}

-   This chapter looked at AI in general since its early history and then focused on AI assistants in particular.

## References {#references .unnumbered}

Abigail Cain. 2017. “The Life and Death of Microsoft Clippy, the Paper Clip the World Loved to Hate.” *Artsy*. https://www.artsy.net/article/artsy-editorial-life-death-microsoft-clippy-paper-clip-loved-hate.

Akata, Zeynep, Dan Balliet, Maarten De Rijke, Frank Dignum, Virginia Dignum, Guszti Eiben, Antske Fokkens, et al. 2020. “A Research Agenda for Hybrid Intelligence: Augmenting Human Intellect With Collaborative, Adaptive, Responsible, and Explainable Artificial Intelligence.” *Computer* 53 (8): 18–28. <https://doi.org/10.1109/MC.2020.2996587>.

Akshay Kore. 2022. *Designing Human-Centric AI Experiences: Applied UX Design for Artificial Intelligence*. Apress.

Alex Tamkin, and Deep Ganguli. 2021. “How Large Language Models Will Transform Science, Society, and AI.” https://hai.stanford.edu/news/how-large-language-models-will-transform-science-society-and-ai.

Amershi, Saleema, Dan Weld, Mihaela Vorvoreanu, Adam Fourney, Besmira Nushi, Penny Collisson, Jina Suh, et al. 2019. “Guidelines for Human-AI Interaction.” In *CHI 2019*. ACM.

Anderson, Marian. 2020. “5 Ways Artificial Intelligence Helps in Improving Website Usability.” *IEEE Computer Society*. https://www.computer.org/publications/tech-news/trends/5-ways-artificial-intelligence-helps-in-improving-website-usability/.

Architechtures. 2020. “What Is Artificial Intelligence Aided Design?” *Architechtures*.

Babich, Nick. 2019. “Interaction Design Vs UX: What’s the Difference?” *Adobe XD Ideas*.

Barbara Friedberg. 2021. “M1 Finance Vs <span class="nocase">Betterment Robo Advisor Comparison-by Investment Expert</span>.”

Barrett, Brian. 2019. “McDonald’s Acquires Machine-Learning Startup Dynamic Yield for \$300 Million.” *Wired*, March.

Battistoni, Pietro, Marianna Di Gregorio, Marco Romano, Monica Sebillo, and Giuliana Vitiello. 2023. “Can AI-Oriented Requirements Enhance Human-Centered Design of Intelligent Interactive Systems? Results from a Workshop with Young HCI Designers.” *MTI* 7 (3): 24. <https://doi.org/10.3390/mti7030024>.

Bedtimestory.ai. 2023. “AI Powered Story Creator \| Bedtimestory.ai.” https://bedtimestory.ai.

Benjamin Cassidy. 2022. “The Twisted Life of Clippy.” *Seattle Met*, August.

Bill Gates. 1982. “Bill Gates on the Next 40 Years in Technology.”

Bolei Zhou. 2022. “CVPR’22 Tutorial on Human-Centered AI for Computer Vision.” https://human-centeredai.github.io/.

Bowman, Samuel R. 2023. “Eight Things to Know about Large Language Models.” <https://doi.org/10.48550/ARXIV.2304.00612>.

Brent A. Anders. 2022. “Why ChatGPT Is Such a Big Deal for Education.” *C2C Digital Magazine* Vol. 1 (18).

Brown, Angie. 2021. “How Financial Chatbots Can Benefit Your Business.” *Medium*.

Bubeck, Sébastien, Varun Chandrasekaran, Ronen Eldan, Johannes Gehrke, Eric Horvitz, Ece Kamar, Peter Lee, et al. 2023. “Sparks of Artificial General Intelligence: Early Experiments with GPT-4.” <https://doi.org/10.48550/ARXIV.2303.12712>.

“Buoy Health: Check Symptoms & Find the Right Care.” n.d. https://www.buoyhealth.com. Accessed June 27, 2023.

Cabitza, Federico, Andrea Campagner, Gianclaudio Malgieri, Chiara Natali, David Schneeberger, Karl Stoeger, and Andreas Holzinger. 2023. “Quod Erat Demonstrandum? - Towards a Typology of the Concept of Explanation for the Design of Explainable AI.” *Expert Systems with Applications* 213: 118888. <https://doi.org/10.1016/j.eswa.2022.118888>.

Cahan, Patrick, and Barbara Treutlein. 2023. “A Conversation with ChatGPT on the Role of Computational Systems Biology in Stem Cell Research.” *Stem Cell Reports* 18 (1): 1–2. <https://doi.org/10.1016/j.stemcr.2022.12.009>.

Calisto, Francisco Maria, Carlos Santiago, Nuno Nunes, and Jacinto C. Nascimento. 2021. “Introduction of Human-Centric AI Assistant to Aid Radiologists for Multimodal Breast Image Classification.” *International Journal of Human-Computer Studies* 150 (June): 102607. <https://doi.org/10.1016/j.ijhcs.2021.102607>.

———. 2022. “BreastScreening-AI: Evaluating Medical Intelligent Agents for Human-AI Interactions.” *Artificial Intelligence in Medicine* 127 (May): 102285. <https://doi.org/10.1016/j.artmed.2022.102285>.

CapInstitute. 2023. “Getting Real about Artificial Intelligence - Episode 4.”

Casper Kessels. 2022a. “Is Voice Interaction a Solution to Driver Distraction?” *The Turn Signal - a Blog About Automotive UX Design*. https://theturnsignalblog.com.

———. 2022b. “Guidelines for Designing an In-Car Voice Assistant.” *The Turn Signal - a Blog About Automotive UX Design*. https://theturnsignalblog.com.

CBS Mornings. 2023. “Full Interview: "Godfather of Artificial Intelligence" Talks Impact and Potential of AI.”

Celino, Irene, and Gloria Re Calegari. 2020. “Submitting Surveys via a Conversational Interface: An Evaluation of User Acceptance and Approach Effectiveness.” *International Journal of Human-Computer Studies* 139: 102410. <https://doi.org/10.1016/j.ijhcs.2020.102410>.

“Charisma Storytelling Powered by Artificial Intelligence.” n.d. https://charisma.ai/. Accessed June 25, 2023.

Cheng, Xusen, Xiaoping Zhang, Bo Yang, and Yaxin Fu. 2022. “An Investigation on Trust in <span class="nocase">AI-enabled</span> Collaboration: Application of AI-Driven Chatbot in Accommodation-Based Sharing Economy.” *Electronic Commerce Research and Applications* 54 (July): 101164. <https://doi.org/10.1016/j.elerap.2022.101164>.

Clipdrop. n.d. “Create Stunning Visuals in Seconds with AI.” https://clipdrop.co/. Accessed June 25, 2023.

Combi, Carlo, Beatrice Amico, Riccardo Bellazzi, Andreas Holzinger, Jason H. Moore, Marinka Zitnik, and John H. Holmes. 2022. “A Manifesto on Explainability for Artificial Intelligence in Medicine.” *Artificial Intelligence in Medicine* 133 (November): 102423. <https://doi.org/10.1016/j.artmed.2022.102423>.

Constandse, Chris. 2018. “How <span class="nocase">AI-driven</span> Website Builders Will Change the Digital Landscape.” *Medium*. https://uxdesign.cc/how-ai-driven-website-builders-will-change-the-digital-landscape-a5535c17bbe.

Costa, Andre, and Firmino Silva. 2022. “Interaction Design for AI Systems: An Oriented State-of-the-Art.” In *2022 International Congress on Human-Computer Interaction, Optimization and Robotic Applications (HORA)*, 1–7. Ankara, Turkey: IEEE. <https://doi.org/10.1109/HORA55278.2022.9800084>.

Crompton, Laura. 2021. “The Decision-Point-Dilemma: Yet Another Problem of Responsibility in Human-AI Interaction.” *Journal of Responsible Technology* 7–8 (October): 100013. <https://doi.org/10.1016/j.jrt.2021.100013>.

David, Daniel Ben, Yehezkel S. Resheff, and Talia Tron. 2021. “Explainable AI and Adoption of Financial Algorithmic Advisors: An Experimental Study.” arXiv. <https://arxiv.org/abs/2101.02555>.

David Johnston. 2023. “Smart Agent Protocol - Community Paper Version 0.2.” *Google Docs*. https://docs.google.com/document/d/1cutU1SerC3V7B8epopRtZUrmy34bf38W–w4oOyRs2A/edit?usp=sharing.

Dávid Pásztor. 2018. “AI UX: 7 Principles of Designing Good AI Products.” https://uxstudioteam.com/ux-blog/ai-ux/.

Design Portland. 2018. “Humans Have the Final Say Stories.” *Design Portland*. https://designportland.org/.

Dignum, Virginia. 2021. “AI the People and Places That Make, Use and Manage It.” *Nature* 593 (7860): 499–500. <https://doi.org/10.1038/d41586-021-01397-x>.

Dot Go. 2023. “Dot Go.” https://dot-go.app/.

Eric Schmidt, and Ben Herold. 2022. *UX: Advanced Method and Actionable Solutions for Product Design Success*.

Eugenia Kuyda. 2023. “Replika.” *Replika.com*. https://replika.com.

Google. 2022. “Google Presents: AI@ ‘22.”

———. n.d. “Our Principles Google AI.” https://ai.google/principles. Accessed November 22, 2022.

Google, and The Oxford Internet Institute. 2022. “The A-Z of AI.” https://atozofai.withgoogle.com/.

Gratch, Jonathan, and Nathanael J. Fast. 2022. “The Power to Harm: AI Assistants Pave the Way to Unethical Behavior.” *Current Opinion in Psychology* 47 (October): 101382. <https://doi.org/10.1016/j.copsyc.2022.101382>.

Greylock. 2022. “OpenAI CEO Sam Altman \| AI for the Next Era.”

Gupta, Ridhima. 2023. “Designing for AI: Beyond the Chatbot.” *Medium*.

Haiyi Zhu, and Steven Wu. 2021. “Human-AI Interaction (Fall 2021).” https://haiicmu.github.io/.

Harvard Advanced Leadership Initiative. 2021. “Human-AI Interaction: From Artificial Intelligence to Human Intelligence Augmentation.”

“Health. Powered by Ada.” n.d. *Ada*. https://ada.com/. Accessed June 25, 2023.

Holbrook, Jess. 2018. “Human-Centered Machine Learning.” *Medium*. https://medium.com/google-design/human-centered-machine-learning-a770d10562cd.

Holzinger, Andreas, Katharina Keiblinger, Petr Holub, Kurt Zatloukal, and Heimo Müller. 2023. “AI for Life: Trends in Artificial Intelligence for Biotechnology.” *New Biotechnology* 74 (May): 16–24. <https://doi.org/10.1016/j.nbt.2023.02.001>.

Holzinger, Andreas, Bernd Malle, Anna Saranti, and Bastian Pfeifer. 2021. “Towards Multi-Modal Causability with Graph Neural Networks Enabling Information Fusion for Explainable AI.” *Information Fusion* 71 (July): 28–37. <https://doi.org/10.1016/j.inffus.2021.01.008>.

“Home - Lark Health.” n.d. https://www.lark.com/. Accessed June 25, 2023.

Isabella Ghassemi Smith. 2019. “Interview: Daniel Baeriswyl, CEO of Magic Carpet \| SeedLegals.” https://seedlegals.com/resources/magic-carpet-the-ai-investor-technology-transforming-hedge-fund-strategy/.

Jeblick, Katharina, Balthasar Schachtner, Jakob Dexl, Andreas Mittermeier, Anna Theresa Stüber, Johanna Topalis, Tobias Weber, et al. 2022. “ChatGPT Makes Medicine Easy to Swallow: An Exploratory Case Study on Simplified Radiology Reports.” <https://doi.org/10.48550/ARXIV.2212.14882>.

Jiang, Qiaolei, Yadi Zhang, and Wenjing Pian. 2022. “Chatbot as an Emergency Exist: Mediated Empathy for Resilience via Human-AI Interaction During the COVID-19 Pandemic.” *Information Processing & Management* 59 (6): 103074. <https://doi.org/10.1016/j.ipm.2022.103074>.

Josephine Wäktare Heintz. n.d. “Cleo.” *👀*. http://www.josephineheintzwaktare.com/cleo. Accessed June 25, 2023.

Josh Lovejoy. n.d. “The UX of AI.” *Google Design*. https://design.google/library/ux-ai. Accessed June 26, 2023.

Kanza, Samantha, Colin Leonard Bird, Mahesan Niranjan, William McNeill, and Jeremy Graham Frey. 2021. “The AI for Scientific Discovery Network+.” *Patterns* 2 (1): 100162. <https://doi.org/10.1016/j.patter.2020.100162>.

Karpus, Jurgis, Adrian Krüger, Julia Tovar Verba, Bahador Bahrami, and Ophelia Deroy. 2021. “Algorithm Exploitation: Humans Are Keen to Exploit Benevolent AI.” *iScience* 24 (6): 102679. <https://doi.org/10.1016/j.isci.2021.102679>.

Kecht, Christoph, Andreas Egger, Wolfgang Kratsch, and Maximilian Röglinger. 2023. “Quantifying Chatbots’ Ability to Learn Business Processes.” *Information Systems*, January, 102176. <https://doi.org/10.1016/j.is.2023.102176>.

Khosravi, Hassan, Simon Buckingham Shum, Guanliang Chen, Cristina Conati, Yi-Shan Tsai, Judy Kay, Simon Knight, Roberto Martinez-Maldonado, Shazia Sadiq, and Dragan Gašević. 2022. “Explainable Artificial Intelligence in Education.” *Computers and Education: Artificial Intelligence* 3: 100074. <https://doi.org/10.1016/j.caeai.2022.100074>.

Kore.ai. 2023. “Homepage.” *Kore.ai*. https://kore.ai/.

Leite, Michel L., Lorena S. de Loiola Costa, Victor A. Cunha, Victor Kreniski, Mario de Oliveira Braga Filho, Nicolau B. da Cunha, and Fabricio F. Costa. 2021. “Artificial Intelligence and the Future of Life Sciences.” *Drug Discovery Today* 26 (11): 2515–26. <https://doi.org/10.1016/j.drudis.2021.07.002>.

Lennart Ziburski. 2018. “The UX of AI.” https://uxofai.com/.

Lew, Gavin, and Robert M. Jr Schumacher. 2020. *AI and UX: Why Artificial Intelligence Needs User Experience*. Berkeley, CA: Apress.

Lexow, Marielle. 2021. “Designing for AI a UX Approach.” *Medium*. https://uxdesign.cc/artificial-intelligence-in-ux-design-54ad4aa28762.

Li, Tianyi, Mihaela Vorvoreanu, Derek DeBellis, and Saleema Amershi. 2022. “Assessing Human-AI Interaction Early Through Factorial Surveys: A Study on the Guidelines for Human-AI Interaction.” *ACM Transactions on Computer-Human Interaction*, April.

Li, Xinge, and Yongjun Sung. 2021. “Anthropomorphism Brings Us Closer: The Mediating Role of Psychological Distance in User Assistant Interactions.” *Computers in Human Behavior* 118 (May): 106680. <https://doi.org/10.1016/j.chb.2021.106680>.

Liang, Percy, Rishi Bommasani, Tony Lee, Dimitris Tsipras, Dilara Soylu, Michihiro Yasunaga, Yian Zhang, et al. 2022. “Holistic Evaluation of Language Models.” arXiv. <https://arxiv.org/abs/2211.09110>.

Liu, Bingjie, and Lewen Wei. 2021. “Machine Gaze in Online Behavioral Targeting: The Effects of Algorithmic Human Likeness on Social Presence and Social Influence.” *Computers in Human Behavior* 124 (November): 106926. <https://doi.org/10.1016/j.chb.2021.106926>.

Liu, Shikun, Linxi Fan, Edward Johns, Zhiding Yu, Chaowei Xiao, and Anima Anandkumar. 2023. “Prismer: A Vision-Language Model with An Ensemble of Experts.” <https://doi.org/10.48550/ARXIV.2303.02506>.

Lorenzo, Doreen, Doreen Lorenzo, and Doreen Lorenzo. 2015. “Daisy Ginsberg Imagines A Friendlier Biological Future.” *Fast Company*. https://www.fastcompany.com/3051140/daisy-ginsberg-is-natures-most-deadly-synthetic-designer.

Lower, Cooper. 2017. “Chatbots: Too Good to Be True? (They Are, Here’s Why).” *Clinc*.

Lv, Xingyang, Jingjing Luo, Yuqing Liang, Yuqing Liu, and Chunxiao Li. 2022. “Is Cuteness Irresistible? The Impact of Cuteness on Customers’ Intentions to Use AI Applications.” *Tourism Management* 90 (June): 104472. <https://doi.org/10.1016/j.tourman.2021.104472>.

Martínez-Plumed, Fernando, Emilia Gómez, and José Hernández-Orallo. 2021. “Futures of Artificial Intelligence Through Technology Readiness Levels.” *Telematics and Informatics* 58 (May): 101525. <https://doi.org/10.1016/j.tele.2020.101525>.

Microsoft. 2023. “Microsoft Designer - Stunning Designs in a Flash.”

Mikael Eriksson Björling, and Ahmed H. Ali. n.d. “UX Design in AI, A Trustworthy Face for the AI Brain.” *Ericsson*. Accessed June 25, 2023.

Nathan Benaich, and Ian Hogarth. 2022. “State of AI Report 2022.” https://www.stateof.ai/.

NeuralNine. 2021. “Financial AI Assistant in Python.”

Nick Clegg. 2023. “How AI Influences What You See on Facebook and Instagram.” *Meta*.

Noble, Stephanie M., Martin Mende, Dhruv Grewal, and A. Parasuraman. 2022. “The Fifth Industrial Revolution: How Harmonious Human Is Triggering a Retail and Service \[R\]evolution.” *Journal of Retailing* 98 (2): 199–208. <https://doi.org/10.1016/j.jretai.2022.04.003>.

O’Connor, Siobhan, and ChatGPT. 2023. “Open Artificial Intelligence Platforms in Nursing Education: Tools for Academic Progress or Abuse?” *Nurse Education in Practice* 66 (January): 103537. <https://doi.org/10.1016/j.nepr.2022.103537>.

Orozco, Luis Guillermo Natera, Federico Battiston, Gerardo Iñiguez, and Michael Szell. 2020. “Budapest Bicycle Network Growth; Manhattan Bicycle Network Growth from <span class="nocase">Data-driven</span> Strategies for Optimal Bicycle Network Growth,” 7642364 Bytes. <https://doi.org/10.6084/M9.FIGSHARE.13336684.V1>.

patrizia-slongo. 2020. “<span class="nocase">AI-powered</span> Tools for Web Designers 🤖.” *Medium*. https://blog.prototypr.io/ai-powered-tools-for-web-designers-adc97530a7f0.

Pavlik, John V. 2023. “Collaborating With ChatGPT: Considering the Implications of Generative Artificial Intelligence for Journalism and Media Education.” *Journalism & Mass Communication Educator* 78 (1): 84–93. <https://doi.org/10.1177/10776958221149577>.

Picard, Rosalind W. 1997. *Affective Computing*. Cambridge, Mass: MIT Press.

Qorus. 2023. “The Great Reinvention: The Global Digital Banking Radar 2023.”

Ramchurn, Sarvapali D., Sebastian Stein, and Nicholas R. Jennings. 2021. “Trustworthy Human-AI Partnerships.” *iScience* 24 (8): 102891. <https://doi.org/10.1016/j.isci.2021.102891>.

ReadyAI. 2020. *Human-AI Interaction: How We Work with Artificial Intelligence*.

Schoonderwoerd, Tjeerd A. J., Wiard Jorritsma, Mark A. Neerincx, and Karel van den Bosch. 2021. “Human-Centered XAI: Developing Design Patterns for Explanations of Clinical Decision Support Systems.” *International Journal of Human-Computer Studies* 154 (October): 102684. <https://doi.org/10.1016/j.ijhcs.2021.102684>.

Searls, Doc. 2012. *The Intention Economy: When Customers Take Charge*. Boston, Mass: Harvard Business Review Press.

Seeber, Isabella, Eva Bittner, Robert O. Briggs, Triparna de Vreede, Gert-Jan de Vreede, Aaron Elkins, Ronald Maier, et al. 2020. “Machines as Teammates: A Research Agenda on AI in Team Collaboration.” *Information & Management* 57 (2): 103174. <https://doi.org/10.1016/j.im.2019.103174>.

September 16, 2020. 2020. “What Is <span class="nocase">AI-assisted Design</span>? \| Renumics GmbH.” https://renumics.com/blog/what-is-ai-assisted-design/.

Şerban, Camelia, and Ioana-Alexandra Todericiu. 2020. “Alexa, What Classes Do I Have Today? The Use of Artificial Intelligence via Smart Speakers in Education.” *Procedia Computer Science* 176: 2849–57. <https://doi.org/10.1016/j.procs.2020.09.269>.

Shenoi, Sanjana. 2018. “Participatory Design and the Future of Interaction Design.” *Medium*. https://uxdesign.cc/participatory-design-and-the-future-of-interaction-design-81a11713bbf.

Shin, Donghee. 2020. “How Do Users Interact with Algorithm Recommender Systems? The Interaction of Users, Algorithms, and Performance.” *Computers in Human Behavior* 109 (August): 106344. <https://doi.org/10.1016/j.chb.2020.106344>.

Shin, Don, Bu Zhong, and Frank Biocca. 2020. “Beyond User Experience: What Constitutes Algorithmic Experiences?” *International Journal of Information Management* 52 (January): 102061. <https://doi.org/10.1016/j.ijinfomgt.2019.102061>.

Simon Sterne. 2023. “Unlocking the Power of Design to Help Users Make Smart Decisions.” *Web Designer Depot*.

Singer, Uriel, Adam Polyak, Thomas Hayes, Xiaoyue Yin, Jie An, Songyang Zhang, Qiyuan Hu, et al. 2022. “Make-<span class="nocase">A-video</span>: <span class="nocase">Text-to-video</span> Generation Without Text-Video Data.” *ArXiv* abs/2209.14792.

Slack, Justin. 2021. “The Atura Process.” *Atura Website*. https://atura.ai/docs/02-process/.

Soleimani, Lailee. 2018. “10 UI Patterns For a Human Friendly AI.” *Medium*. https://blog.orium.com/10-ui-patterns-for-a-human-friendly-ai-e86baa2a4471.

Stanford Encyclopedia of Philosophy. 2021. “The Turing Test.” https://plato.stanford.edu/entries/turing-test/.

Steph Hay. 2017. “Eno - Financial AI Understands Emotions.” *Capital One*. https://www.capitalone.com/tech/machine-learning/designing-a-financial-ai-that-recognizes-and-responds-to-emotion/.

Stephanie Donahole. 2021. “How Artificial Intelligence Is Impacting UX Design.” *UXmatters*. https://www.uxmatters.com/mt/archives/2021/04/how-artificial-intelligence-is-impacting-ux-design.php.

Stone Skipper. 2022. “How AI Is Changing ‘Interactions’.” *Medium*. https://uxplanet.org/how-ai-is-changing-interactions-179cc279e545.

*Studies in Conversational UX Design*. 2018. New York, NY: Springer Berlin Heidelberg.

Su, Jiahong, Davy Tsz Kit Ng, and Samuel Kai Wah Chu. 2023. “Artificial Intelligence (AI) Literacy in Early Childhood Education: The Challenges and Opportunities.” *Computers and Education: Artificial Intelligence* 4: 100124. <https://doi.org/10.1016/j.caeai.2023.100124>.

Su, Jiahong, and Weipeng Yang. 2022. “Artificial Intelligence in Early Childhood Education: A Scoping Review.” *Computers and Education: Artificial Intelligence* 3: 100049. <https://doi.org/10.1016/j.caeai.2022.100049>.

Suen, Hung-Yue, and Kuo-En Hung. 2023. “Building Trust in Automatic Video Interviews Using Various AI Interfaces: Tangibility, Immediacy, and Transparency.” *Computers in Human Behavior* 143 (June): 107713. <https://doi.org/10.1016/j.chb.2023.107713>.

Szczuka, Jessica M., Clara Strathmann, Natalia Szymczyk, Lina Mavrina, and Nicole C. Krämer. 2022. “How Do Children Acquire Knowledge about Voice Assistants? A Longitudinal Field Study on Children’s Knowledge about How Voice Assistants Store and Process Data.” *International Journal of Child-Computer Interaction* 33 (September): 100460. <https://doi.org/10.1016/j.ijcci.2022.100460>.

Tamkin, Alex, Miles Brundage, Jack Clark, and Deep Ganguli. 2021. “Understanding the Capabilities, Limitations, and Societal Impact of Large Language Models.” arXiv. <https://doi.org/10.48550/arxiv.2102.02503>.

Tang, Jerry, Amanda LeBel, Shailee Jain, and Alexander G. Huth. 2022. “Semantic Reconstruction of Continuous Language from Non-Invasive Brain Recordings.” Preprint. Neuroscience. <https://doi.org/10.1101/2022.09.29.509744>.

Tash Keuneman. 2022. “We Love to Hate Clippy but What If Clippy Was Right?” *UX Collective*. https://uxdesign.cc/we-love-to-hate-clippy-but-what-if-clippy-was-right-472883c55f2e.

The International Ergonomics Association. 2019. “Human Factors/Ergonomics (HF/E).” https://iea.cc/what-is-ergonomics/.

Tom Hathaway, and Angela Hathaway. 2021. *Chatting with Humans: User Experience Design (UX) for Chatbots: Simplified Conversational Design and <span class="nocase">Science-based Chatbot Copy</span> That Engages People*.

Tristan Greene. 2022. “Confused Replika AI Users Are Trying to Bang the Algorithm.” *TNW*. https://thenextweb.com/news/confused-replika-ai-users-are-standing-up-for-bots-trying-bang-the-algorithm.

Tubik Studio. 2018. “UX Design Glossary: How to Use Affordances in User Interfaces.” *Medium*. https://uxplanet.org/ux-design-glossary-how-to-use-affordances-in-user-interfaces-393c8e9686e4.

Turing, A. M. 1950. “I.” *Mind* LIX (236): 433–60. <https://doi.org/10.1093/mind/LIX.236.433>.

Twitter. 2023. “Twitter’s Recommendation Algorithm.” Twitter.

Unleash. 2017. “Sebastian.ai.” *UNLEASH*.

van Wynsberghe, Aimee. 2021. “Sustainable AI: AI for Sustainability and the Sustainability of AI.” *AI Ethics* 1 (3): 213–18. <https://doi.org/10.1007/s43681-021-00043-6>.

Veitch, Erik, and Ole Andreas Alsos. 2022. “A Systematic Review of Human-AI Interaction in Autonomous Ship Systems.” *Safety Science* 152 (August): 105778. <https://doi.org/10.1016/j.ssci.2022.105778>.

VideoLecturesChannel. 2022. “Communication in Human-AI Interaction.”

Vinuesa, Ricardo, Hossein Azizpour, Iolanda Leite, Madeline Balaam, Virginia Dignum, Sami Domisch, Anna Felländer, Simone Daniela Langhans, Max Tegmark, and Francesco Fuso Nerini. 2020. “The Role of Artificial Intelligence in Achieving the Sustainable Development Goals.” *Nat Commun* 11 (1): 233. <https://doi.org/10.1038/s41467-019-14108-y>.

Wang, Zhengwei, Qi She, Alan F. Smeaton, Tomás E. Ward, and Graham Healy. 2020. “Synthetic-Neuroscore: Using a Neuro-AI Interface for Evaluating Generative Adversarial Networks.” *Neurocomputing* 405 (September): 26–36. <https://doi.org/10.1016/j.neucom.2020.04.069>.

“Why UX Should Guide AI.” 2021. *VentureBeat*.

Women in AI. n.d. “How Can AI Assistants Help Patients Monitor Their Health?” *Spotify*. https://open.spotify.com/episode/3dL4m7ciCY0tnirZT2emzs. Accessed November 22, 2020.

Yang, Weipeng. 2022. “Artificial Intelligence Education for Young Children: Why, What, and How in Curriculum Design and Implementation.” *Computers and Education: Artificial Intelligence* 3: 100061. <https://doi.org/10.1016/j.caeai.2022.100061>.

Yuan, Chunlin, Chenlei Zhang, and Shuman Wang. 2022. “Social Anxiety as a Moderator in Consumer Willingness to Accept AI Assistants Based on Utilitarian and Hedonic Values.” *Journal of Retailing and Consumer Services* 65 (March): 102878. <https://doi.org/10.1016/j.jretconser.2021.102878>.

Zafar, Nadiya, and Jameel Ahamed. 2022. “Emerging Technologies for the Management of COVID19: A Review.” *Sustainable Operations and Computers* 3: 249–57. <https://doi.org/10.1016/j.susoc.2022.05.002>.

Zakariya, Candice. 2022. “Stop Using Jasper Art: Use the New Canva AI Image Generator \[Video\].” *ILLUMINATION*.

Zerilli, John, Umang Bhatt, and Adrian Weller. 2022. “How Transparency Modulates Trust in Artificial Intelligence.” *Patterns* 3 (4): 100455. <https://doi.org/10.1016/j.patter.2022.100455>.

Zhang, Guanglu, Leah Chong, Kenneth Kotovsky, and Jonathan Cagan. 2023. “Trust in an AI Versus a Human Teammate: The Effects of Teammate Identity and Performance on Human-AI Cooperation.” *Computers in Human Behavior* 139: 107536. <https://doi.org/10.1016/j.chb.2022.107536>.

Zhang, Shihan. 2018. “Personal Carbon Economy.” http://www.shihanzhang.com/new-page-3.

Zimmerman, John, Changhoon Oh, Nur Yildirim, Alex Kass, Teresa Tung, and Jodi Forlizzi. 2021. “UX Designers Pushing AI in the Enterprise: A Case for Adaptive UIs.” *Interactions* 28 (1): 72–77. <https://doi.org/10.1145/3436954>.
