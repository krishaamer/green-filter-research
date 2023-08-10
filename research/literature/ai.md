---
title: Artificial Intelligence
bibliography: [../ref.bib]
csl: ../harvard.csl
sidebar_position: 3
editor:
    render-on-save: false
---

export const quartoRawHtml =
[`<!-- -->`,`<!-- -->`];

``` mdx-code-block
import Figure from '/src/components/Figure'
import AI from '../images/ai-credibility-heuristic-systematic-model.png'
import Replika from '../images/with-me.png'
import Runaround from '../images/runaround.png'
```

## Human-AI Interaction {#human-ai-interaction}

### History of AI {#history-of-ai}

It’s been 90 years since (McCulloch and Pitts, 1943) proposed the first mathematical model of a neural network inspired by the human brain, followed by Alan Turing’s Test for Machine Intelligence in 1950. Artificial Intelligence (AI) has developed from an academic concept into a mainstream reality, affecting our daily lives, even when we don’t notice it - AI is everywhere.

Turing’s initial idea was to design a game of imitation to test human-computer interaction using text messages between a human and 2 other participants, one of which was a human, and the other - a computer. The question was, if the human was simultaneously speaking to another human and a machine, could the messages from the machine be clearly distinguished or would they resemble a human being so much, that the person asking questions would be deceived, unable to realize which one is the human and which one is the machine? Turing (1950).

> Alan Turing: *“I believe that in about fifty years’ time it will be possible to program computers, with a storage capacity of about 10<sup>9</sup>, to make them play the imitation game so well that an average interrogator will not have more than 70 percent chance of making the right identification after five minutes of questioning. … I believe that at the end of the century the use of words and general educated opinion will have altered so much that one will be able to speak of machines thinking without expecting to be contradicted.”* - from (Stanford Encyclopedia of Philosophy, 2021)

By the 2010s AI models became capable enough to beat humans in games of Go and Chess, yet they did not yet pass the Turing test. AI use was limited to specific tasks. While over the years, the field of AI had seen a long process of incremental improvements, developing increasingly advanced models of decision-making, it took an ***increase in computing power*** and an approach called ***deep learning***, a variation of ***machine learning (1980s),*** largely modeled after the ***neural networks*** of the biological (human) brain, returning to the idea of ***biomimicry***, inspired by nature, building a machine to resemble the connections between neurons, but digitally, on layers much deeper than attempted before.

The nature–inspired approach was successful, and together with many other innovations, such as ***back-propagation***, ***transformers***, which allow tracking relationships in sequential data (for example sentences) (Vaswani et al., 2017; Merritt, 2022), Generative Adversarial Networks\*\*\* (GAN), (**CITE, 2016**), and ***Large Language Models (CITE, 2018)***, led to increasingly generalized models, capable of more complex tasks, such as language generation. One of the leading scientists in this field of research, Geoffrey Hinton, had attempted back-propagation already in the 1980s and reminiscents how “the only reason neural networks didn’t work in the 1980s was because we didn’t have have enough data and we didn’t have enough computing power” (CBS Mornings, 2023).

By the 2020s, AI-based models became a mainstay in medical research, drug development, patient care (Leite et al., 2021; Holzinger et al., 2023), quickly finding potential vaccine candidates during the COVID19 pandemic (Zafar and Ahamed, 2022), self-driving vehicles, including cars, delivery robots, drones in the sea and air, as well as AI-based assistants, which will be the focus here.

In 2020 OpenAI released a LLM called GPT-3 trained on 570 GB of text Alex Tamkin and Deep Ganguli (2021). Singer et al. (2022) describes how collecting billions of images with descriptive data (for example the descriptive *alt* text which accompanies images on websites) has enabled researchers to train AI models such as ***stable diffusion*** that can generate images based on human-language.

Hinton likes to call AI an *idiot savant*, someone with exceptional aptitude yet serious mental disorder. Large AI models don’t understand the world like humans do. Their responses are predictions based on their training data and complex statistics. Indeed, the comparison may be apt, as the AI field now offers jobs for *AI psychologists (CITE)*, whose role is to figure out what exactly is happening inside the ‘AI brain’. Understading the insides of AI models trained of massive amounts of data is important because they are ***foundational***, enabling a holistic approach to learning, combining many disciplines using languages, instead of the reductionist way we as human think because of our limitations CapInstitute (2023).

### Generative AI {#generative-ai}

Foundational AI models have given birth to ***generative AI***, which is able to generate ***tokens,*** such as text, speech, audio (Kreuk et al., 2022; San Roman et al., 2023), and even music (Copet et al., 2023; Meta AI, 2023), video, in any language it’s trained on, but also complex structures such 3D models and even genomes. Generative AI brought a revolution in human-AI interaction as AI models became increasingly capable of producing human–like content. The advances in the capabilities of large AI model mean we’ve reached a point, where ***it’s possible to achieve a user experience (UX) which previously was science fiction***.

Noble et al. (2022) proposes AI has reached a stage, which begets the beginning of the ***5th industrial revolution*** which brings the collaboration of humans and AI. Widespread **Internet of Things (IoT)** sensor networks that gather data, which is then analyzed AI algorithms, integrates computing even deeper into the fabric of daily human existence. Several terms of different origin but considerable overlap describe this phenomenon, including ***Pervasive Computing (PC)*** and ***Ubiquitous Computing***. Similar concepts are ***Ambient Computing***, which focuses more on the invisibility of technology, fading into the background, without us, humans, even noticing it, and ***Calm Technology***, which highlights how technology respects humans and our limited attention spans, and doesn’t call attention to itself. In all cases, AI is integral part of our everyday life, inside everything and everywhere.

This power comes with ***increased need for responsibility***, drawing growing interest in fields like ***AI ethics*** and ***AI explainability.*** Generative has a potential for misuse, as humans are increasingly confused by what is computer-generated and what is human-created, unable to distinguish one from the other with certainty.

| AI Model | Released | Company                         | License                       |
|-----------------|-----------------|---------------------|-----------------|
| GPT-1    | 2018     | OpenAI                          | Open Source, MIT              |
| GTP-2    | 2019     | OpenAI                          | Open Source, MIT              |
| T-NLG    | 2000     | Microsoft                       |                               |
| GPT-3    | 2020     | OpenAI                          | Brown, T. B. et al. (2020)    |
| GPT-3.5  | 2022     | OpenAI                          | Proprietary                   |
| GPT-4    | 2023     | OpenAI                          | Proprietary                   |
| GPT-5    | ????     | OpenAI                          | Unknown; trademark registered |
| NeMo     | 2022     | NVIDIA                          |                               |
| PaLM     | 2022     | Google                          |                               |
| LaMDA    | 2022     | Google                          |                               |
| GLaM     | 2022     | Google                          |                               |
| BLOOM    | 2022     | Hugging Face                    | Open Source                   |
| Falcon   | 2023     | Technology Innovation Institute | Open Source                   |
| Tongyi   | 2023     | Alibaba                         |                               |
| Vicuna   | 2023     | Sapling                         | Open Source                   |
| Wu Dao 3 | 2023     | BAAI                            | Open Source                   |

From reports on the advance of LLMs by Tamkin et al. (2021); Hines (2023).

Pete (2023) ChatGPT hackathon.

The quality of LLM output depends on the quality of the provided prompt. Zhou et al. (2022) reports creating an “Automatic Prompt Engineer” which automatically generates instructions that outperform the baseline output quality. This finding has significance for “green filter” as it validates the idea of creating advanced prompts for improved responses. For “green filter”, the input would consist of detailed user data + sustainability data for detailed analysis.

Anon. (2023a) My bedtime story about shopping, saving, and investing.

Tu et al. (2023) LLMs can be used as data analysts.

Rogers (2022) defines the 4 phases of Pervasive Computing. (NEED access).

Kobetz (2023)

## Responsible AI {#responsible-ai}

### Known Issues {#known-issues}

The are two large problems with this generation of LLMs such as GTP3 and GPT4 by OpenAI, Microsoft, Google and Nvidia.

-   LLMs are massive monolithic models requiring large amounts of computing power for training to offer ***multi-modal*** ***capabilities*** across diverse domains of knowledge, making training such models possible for very few companies. Liu, S. et al. (2023) proposes future AI models may instead consist of a number networked domain-specific models to increase efficiency and thus become more scalable.

-   LLMs are also opaque, making it difficult to explain why a certain prediction was made by the AI model. One visible expression of this problem are ***hallucinations**,* the language models are able to generate text that is confident and eloquent yet entirely wrong. Jack Krawczyk, the product lead for Google’s Bard: “Bard and ChatGPT are large language models, not knowledge models. They are great at generating human-sounding text, they are not good at ensuring their text is fact-based. Why do we think the big first application should be Search, which at its heart is about finding true information?”

Given the widespread use of AI and its increasing power of foundational models, it’s important these systems are created in a safe and responsible manner. While there have been calls to pause the development of large AI experiments (Future of Life Institute, 2023) so the world could catch up, this is unlikely to happen.

There’s wide literature available describing human-AI interactions across varied scientific disciplines. While the fields of application are diverse, some key lessons can be transferred horizontally across fields of knowledge.

-   Veitch and Andreas Alsos (2022) highlights the active role of humans in Human-AI interaction is autonomous ship systems.
-   From assistant to companion to friend The best help for anxiety is a friend
-   Crompton (2021) highlights AI as decision-support for humans while differentiating between intended and unintended influence on human decisions.
-   Cheng et al. (2022) describe AI-based support systems for collaboration and team-work.
-   Schoonderwoerd et al. (2021) focuses on human-centered design of AI-apps and multi-modal information display. It’s important to understand the domain where the AI is deployed in order to develop explanations. However, in the real world, how feasible is it to have control over the domain?
-   Ramchurn, Stein and Jennings (2021) discusses positive feed-back loops in continually learning AI systems which adapt to human needs.
-   Karpus et al. (2021) is concerned with humans treating AI badly and coins the term “*algorithm exploitation”.*
-   Lv et al. (2022) studies the effect of ***cuteness*** of AI apps on users and found high perceived cuteness correlated with higher willingness to use the apps, especially for emotional tasks. This finding has direct relevance for the “green filter” app design.
-   Liu, B. and Wei (2021) meanwhile suggests higher algorithmic transparency may inhibit anthropomorphism, meaning people are less likely to attribute humanness to the AI if they understand how the system works.
-   Seeber et al. (2020) proposes a future research agenda for regarding AI assistants as teammates rather than just tools and the implications of such mindset shift.

### Conversational AI {#conversational-ai}

-   People are used to search engines and it will take a little bit time to get familiar with talking to a computer in natural language Bailey (2023). NVIDIA founder Jensen Huang makes the idea exceedingly clear, saying “Everyone is a programmer. Now, you just have to say something to the computer.”Leswing (2023)

-   Because AI responses are unreliable some percentage of the time, they require constant oversight (human-in-the-loop) Bailey (2023).

There are noticeable differences in the quality of the LLM output, which increases with model size. Levesque, Davis and Morgenstern (2012) developed the *Winograd Schema Challenge*, looking to improve on the Turing test, by requiring the AI to display an understanding of language and context. The test consists of a story and a question, which has a different meaning as the context changes: “The trophy would not fit in the brown suitcase because it was too big” - what does the *it* refer to? Humans are able to understand this from context while a computer models would fail. Even GPT-3 still failed the test, but later LLMs have been able to solve this test correctly (90% accuracy) Kocijan et al. (2022). This is to say AI is in constant development and improving it’s ability to make sense of language.

***ChatGPT*** is the first ***user interface (UI)*** built on top of GPT-4 by OpenAI and is able to communicate in a human-like way - using first-person, making coherent sentences that sound plausible, and even - confident and convincing. Wang, M. C., Sarah (2023) ChatGPT reached 1 million users in 5 days and 6 months after launch has 230 million monthly active users.

OpenAI provides AI-as-a-service through its ***application programming interfaces (APIs),*** allowing 3rd party developers to build custom UIs to serve the specific needs of their customer. For example Snapchat has created a ***virtual friend*** called “My AI” who lives inside the chat section of the Snapchat app and helps people write faster with predictive text completion and answering questions. The APIs make state-of-the-art AI models easy to use without needing much technical knowledge. Teams at AI-hackathons have produced interfaces for problems as diverse as humanitarian crises communication, briefing generation, code-completion, and many others. For instance, (Unleash, 2017) used BJ Fogg’s ***tiny habits model*** to develop a sustainability-focused AI assistant at the Danish hackathon series Unleash, to encourage behavioral changes towards maintaining an aspirational lifestyle, nudged by a chatbot buddy.

ChatGPT makes it possible to ***evaluate AI models*** just by talking, i.e. having conversations with the machine and judging the output with some sort of structured content analysis tools. O’Connor and ChatGPT (2023) and Cahan and Treutlein (2023) have conversations about science with AI. Pavlik (2023) and Brent A. Anders (2022) report on AI in education. Kecht et al. (2023) suggests AI is even capable of learning business processes.

-   Fu et al. (2022) Learning towards conversational AI: Survey

### Affective Computing {#affective-computing}

Because of the conversational nature of LLMs, they are very useful for ***affective computing***, an approach to recognizing human emotions with machines and providing users experiences that take human emotion into account Picard (1997).

-   HIITTV (2021a) data from all the processes around us will define the future of computing

Rosalind Picard

-   TEDx Talks (2011)

-   Lex Fridman (2019)

-   HIITTV (2021b)

-   BWH CNOC (2023)

-   Singularity University (2023)

Since the first mainframe computers with rudimentary computers able to respond with text messages, humans have been drawn to discussing their private lives with a machine that doesn’t judge you like a human could. A famous anecdote is about the lab assistant (secretary) of the , who would dedicate time to talking to the machine in private.

Today’s machines are much more capable so it’s not a surprise humans would like to talk to them. One ***AI Friend*** is Replika, a computer model trained to be your companion in daily life. Jiang, Zhang and Pian (2022) describes how Replika users in China using in 5 main ways, all of which rely on empathy.

| How humans express empathy towards an AI companion |
|----------------------------------------------------|
| Companion buddy                                    |
| Responsive diary                                   |
| Emotion-handling program                           |
| Electronic pet                                     |
| Tool for venting                                   |

Replika AI users approach to interacting with the AI friend from Jiang, Zhang and Pian (2022).

### Algorithmic Experience {#algorithmic-experience}

As a user of social media, one may be accustomed to interacting with the feed algorithms that provide a personalized ***algorithmic experience***. Algorithms are more deterministic than AI, meaning they produce predictable output than AI models. Nonetheless, there are many reports about effects these algorithms have on human psychology **(CITE)**. Design is increasingly relevant to algorithms, and more specifically to algorithms that affect user experience and user interfaces. ***When the design is concerned with the ethical, environmental, socioeconomic, resource-saving, and participatory aspects of human-machine interactions and aims to affect technology in a more human direction, it can hope to create an experience designed for sustainability.***

Lorenzo, Lorenzo and Lorenzo (2015) underlines the role of design beyond *designing* as a tool for envisioning; in her words, *“design can set agendas and not necessarily be in service, but be used to find ways to explore our world and how we want it to be”*. Practitioners of Participatory Design (PD) have for decades advocated for designers to become more activist through ***action research***. This means to influencing outcomes, not only being a passive observer of phenomena as a researcher, or only focusing on usability as a designer, without taking into account the wider context.

Shenoi (2018) argues inviting domain expertise into the discussion while having a sustainable design process enables designers to design for experiences where they are not a domain expert; this applies to highly technical fields, such as medicine, education, governance, and in our case here - finance and sustainability -, while building respectful dialogue through participatory design. After many years of political outcry (CITE), social media platforms such Facebook and Twitter have begun to shed more light on how these algorithms work, in some cases releasing the source code (Nick Clegg (2023); Twitter (2023)).

AI systems may make use of several algorithms within one larger model. It follows that AI Explainability requires ***Algorithmic Transparency**.*

The content on the platform can be more important than the interface. Applications with a similar UI depend on the community as well as the content and how the content is shown to the user.

### Guidelines {#guidelines}

A Microsoft Co-Founder predicted in 1982 *“personal agents that help us get a variety of tasks”* (Bill Gates, 1982) and it was Microsoft that introduced the first widely available personal assistant in 1996, called Clippy. Found inside the Microsoft Word software. Clippy was among the first assistants to reach mainstream adoption, helping users not yet accustomed to working on a computer, to get their bearings (Tash Keuneman, 2022). Nonetheless, it was in many ways useless and intrusive, suggesting there was still little knowledge about UX and human-centered design. Might we try again?

With the advent of ChatGPT, the story of Clippy has new relevance as part of the history of AI Assistants. Benjamin Cassidy (2022) and Abigail Cain (2017) illustrate beautifully the story of Clippy and Tash Keuneman (2022) ask poignantly: “We love to hate Clippy — but what if Clippy was right?”

Many researchers have discussed the user experience (UX) of AI to provide ***usability guidelines***.

Microsoft provides guidelines for Human-AI interaction (Li, T. et al. (2022); Amershi et al. (2019)) which provides useful heuristics categorized by context and time.

| Context            | Time |
|--------------------|------|
| Initially          |      |
| During interaction |      |
| When wrong         |      |
| Over time          |      |

Microsoft’s heuristics categorized by context and time.

Combi et al. (2022) proposes a conceptual framework for XAI, analysis AI based on Interpretability, Understandability, Usability, and Usefulness.

-   Zimmerman et al. (2021) “UX designers pushing AI in the enterprise: a case for adaptive UIs”

-   Anon. (2021) “Why UX should guide AI”

-   Simon Sterne (2023) UX is about helping the user make decisions

-   Dávid Pásztor (2018)

-   Anderson (2020)

-   Lennart Ziburski (2018) UX of AI

-   Stephanie Donahole (2021)

-   Lexow (2021)

-   Dávid Pásztor (2018) AI UX principles

-   Bubeck et al. (2023) finds ChatGPT passes many exams meant for humans.

-   Suen and Hung (2023) discusses AI systems used for evaluating candidates at job interviews

-   Wang, Z. et al. (2020) propose Neuroscore to reflect perception of images.

-   Su and Yang (2022) and Su, Ng and Chu (2023) review papers on AI literacy in early childhood education and finds a lack of guidelines and teacher expertise.

-   Yang (2022) proposes a curriculum for in-context teaching of AI for kids.

-   Eric Schmidt and Ben Herold (2022) audiobook

-   Akshay Kore (2022) Designing Human-Centric AI Experiences: Applied UX Design for Artificial Intelligence

-   Anon. (2018) chatbot book

-   Tom Hathaway and Angela Hathaway (2021) chatbot book

-   Lew and Schumacher (2020) AI UX book

-   AI IXD is about human-centered seamless design

-   Storytelling

-   Human-computer interaction (HCI) has a long storied history since the early days of computing when getting a copy machine to work required specialized skill. Xerox Sparc lab focused on early human factors work and inspired a the field of HCI to make computer more human-friendly.

-   Soleimani (2018): UI patterns for AI, new Section for Thesis background: “Human-Friendly UX For AI”?

-   **Discuss what is UX for AI (per prof Liou’s comment), so it’s clear this is about UX for AI**

-   What is Personalized AI?

-   Many large corporations have released guidelines for Human-AI interaction. Mikael Eriksson Björling and Ahmed H. Ali (n.d.) Ericcson AI UX.

-   Google (n.d.) outlines Google’s 7 AI Principles and provides Google’s UX for AI library (Josh Lovejoy, n.d.). In Design Portland (2018), Lovejoy, lead UX designer at Google’s people-centric AI systems department (PAIR), reminds us that while AI offers need tools, user experience design needs to remain human-centered - while AI can find patterns and offer suggestions, humans should always have the final say.

-   Harvard Advanced Leadership Initiative (2021)

-   VideoLecturesChannel (2022) “Communication in Human-AI Interaction”

-   Haiyi Zhu and Steven Wu (2021)

-   Akata et al. (2020)

-   Dignum (2021)

-   Bolei Zhou (2022)

-   ReadyAI (2020)

-   Vinuesa et al. (2020)

-   Orozco et al. (2020)

### AI UX Design {#ai-ux-design}

-   Privacy UX Jarovsky (2022a)

-   AI UX dark patterns Jarovsky (2022b)

-   Bailey (2023) believes people will increasingly use AI capabilities through UIs that are specific to a task rather than generalist interfaces like ChatGPT.

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

-   Shin, Donghee (2020): “user experience and usability of algorithms by focusing on users’ cognitive process to understand how qualities/features are received and transformed into experiences and interaction”

-   Zerilli, Bhatt and Weller (2022) focuses on human factors and ergonomics and argues that transparency should be task-specific.

-   Holbrook (2018): To reduce errors which only humans can detect, and provide a way to stop automation from going in the wrong direction, it’s important to focus on making users feel in control of the technology.

-   Zhang, G. et al. (2023) found humans are more likely to trust an AI teammate if they are not deceived by it’s identity. It’s better for collaboration to make it clear, one is talking to a machine. One step towards trust is the explainability of AI-systems.

Personal AI Assistants to date have we created by large tech companies. **Open-Source AI-models open up the avenue for smaller companies and even individuals for creating many new AI-assistants.**

### AI Acceptance {#ai-acceptance}

AI acceptance is incumbent on traits that are increasingly human-like and would make a human be acceptable: credibility, trustworthiness, reliability, dependability, integrity, character, etc.

RQ: Does AI acceptance increase with Affective Computing?

**AI is being use in high–Stakes Situations (Medical, Cars, Etc).**

AI-based systems are already being implemented in medicine, where stakes are high raising the need for ethical considerations. Since CADUCEUS in the 1970s (in Kanza et al. (2021)), the first automated medical decision making system, medical AI now provides Health Diagnosic Symptoms and AI-assistants in medical imaging. Calisto et al. (2022) focuses on AI-human interactions in medical workflows and underscores the importance of output explainability. Medical professionals who were given AI results with an explanation trusted the results more. Lee, Goldberg and Kohane (2023) imagines an AI revolution in medicine using GPT models, providing improved tools for decreasing the time and money spent on administrative paperwork while providing a support system for analyzing medical data.

-   Singhal et al. (2023) medial AI reaching expert-level question-answering ability.

-   Ayers et al. (2023) in an online text-based setting, patients rated answers from the AI better, and more empathetic, than answers from human doctors.

-   Daisy Wolf and Pande Vijay (2023) critizes US healthcare’s slow adpotion of technology and predicts AI will help healthcare leapfrog into a new era of productivity by acting more like a human assistant.

-   Eliza Strickland (2023)

-   Jeblick et al. (2022) suggest complicated radiology reports can be explained to patients using AI chatbots.

-   Anon. (n.d.a) health app, “Know and track your symptoms”

-   Anon. (n.d.b) AI symptom checker,

-   Women in AI (n.d.)

-   Anon. (n.d.c)

-   Stephanie Donahole (2021)

-   Calisto et al. (2021)

-   Yuan, Zhang and Wang (2022): “AI assistant advantages are important factors affecting the *utilitarian/hedonic* value perceived by users, which further influence user willingness to accept AI assistants. The relationships between AI assistant advantages and utilitarian and hedonic value are affected differently by social anxiety.”

| Name     | Features                           |
|----------|------------------------------------|
| Charisma |                                    |
| Replika  | Avatar, Emotion, Video Call, Audio |
| Siri     | Audio                              |

### AI Friends and Roleplay {#ai-friends-and-roleplay}

Calling a machine a friend is a proposal bound to turn heads. But if we take a step back and think about how children have been playing with toys since before we have records of history. It’s very common for children to imagine stories and characters in play - it’s a way to develop one’s imagination ***learn through roleplay***. A child might have toys with human names and an imaginary friend and it all seems very normal. Indeed, if a child doesn’t like to play with toys, we might think something is wrong.

Likewise, inanimate objects with human form have had a role to play for adults too. Anthropomorphic paddle dolls have been found from Egyptian tombs dated 2000 years B.C. Anon. (2023b): We don’t know if these dolls were for religious purposes, for play, or for something else, yet their burial with the body underlines their importance.

Coming back closer to our own time, Barbie dolls are popular since their release in 1959 till today. Throughout the years, the doll would follow changing social norms, but retain in human figure. In the 1990s, a Tamagotchi is perhaps not a human-like friend but an animal-like friend, who can interact in limited ways.

How are conversational AIs different from dolls? They can respond coherently and perhaps that’s the issue - they are too much like humans in their communication. We have crossed the ***Uncanny Valley*** (where the computer-generated is nearly human and thus unsettling) to a place where is really hard to tell a difference. And if that’s the case, are we still playing?

Should the AI play a human, animal, or robot? Anthropomorphism can have its drawbacks. Pilacinski et al. (2023) reports humans were less likely to collaborate with red-eyed robots.

The AI startups like Inworld and Character.AI have raised large rounds of funding to create characters, which can be plugged in into online worlds, and more importantly, remember key facts about the player, such as their likes and dislikes, to generate more natural-sounding dialoguues Wiggers (2023)

-   Lenharo (2023) experimental study reports AI productivity gains, DALL-E and ChatGPT are qualitatively better than former automation systems.

#### Human-like {#human-like}

As AIs became more expressive and able to to **roleplay**, we can begin discussing some human-centric concepts and how people relate to other people. AI companions, AI partners, AI assistants, AI trainers - there’s are many **roles** for the automated systems that help humans in many activities, powered by artificial intelligence models and algorithms.

-   RQ: Do college students prefer to talk to an Assistant, Friend, Companion, Coach, Trainer, or some other Role?

-   RQ: Are animal-like, human-like or machine-like AI companions more palatable to college students?

Humans (want to) see machines as human \[CITE\]

If we see the AI as being in human service. David Johnston (2023) proposes ***Smart Agents***, “general purpose AI that acts according to the goals of an individual human”. AI agents can enable ***Intention Economy*** where one simply describes one’s needs and a complex orchestration of services ensues, managed by the the AI, in order to fulfill human needs Searls (2012). AI assistants provide help at scale with little to no human intervention in a variety of fields from finance to healthcare to logistics to customer support.

There is also the question of who takes responsibility for the actions take by the AI agent. “Organization research suggests that acting through human agents (i.e., the problem of indirect agency) can undermine ethical forecasting such that actors believe they are acting ethically, yet a) show less benevolence for the recipients of their power, b) receive less blame for ethical lapses, and c) anticipate less retribution for unethical behavior.” Gratch and Fast (2022)

-   Anthropomorphism literature Li, X. and Sung (2021) “high-anthropomorphism (vs. low-anthropomorphism) condition, participants had more positive attitudes toward the AI assistant, and the effect was mediated by psychological distance. Though several studies have demonstrated the effect of anthropomorphism, few have probed the underlying mechanism of anthropomorphism thoroughly”

<div dangerouslySetInnerHTML={{ __html: quartoRawHtml[0] }} />

-   Erik Brynjolfsson (2022)

-   Xu and Sar (2018)

-   Martínez-Plumed, Gómez and Hernández-Orallo (2021) envisions the future of AI

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

-   David, Resheff and Tron (2021)

-   Qorus (2023) Digital banking revolution

-   Lower (2017)

-   Slack (2021)

-   Brown, A. (2021) Financial chatbots

-   hedonic user experience in chatbots Haugeland et al. (2022)

-   Isabella Ghassemi Smith (2019)

-   David, Resheff and Tron (2021)

-   Josephine Wäktare Heintz (n.d.) Cleo copywriter

-   Smaller startups have created digital companions such as Replika (fig. 8), which aims to become your friend, by asking probing questions, telling jokes, and learning about your personality and preferences - to generate more natural-sounding conversations.

-   Already on the market are several financial robo-advisors, built by fintech companies, aiming to provide personalized suggestions for making investments (Betterment, Wealthfront).

-   Personal carbon footprint calculators have been released online, ranging from those made by governments and companies to student projects.

-   Zhang’s Personal Carbon Economy conceptualized the idea of carbon as a currency used for buying and selling goods and services, as well as an individual carbon exchange to trade one’s carbon permits (Zhang, S. (2018)).

### Voice Assistants {#voice-assistants}

**Amazon Alexa** is a well-known example of AI technology in the world. But Amazon’s Rohit Prasad thinks it can do so much more, “Alexa is not just an AI assistant – it’s a trusted advisor and a companion.”

Ethical issues

-   Voice assistants need to continuously record human speech and process it in data centers in the cloud.

-   Siri, Cortana, Google Assistant, Alexa, Tencent Dingdang, Baidu Xiaodu, Alibaba AliGenie all rely on voice only.

-   Szczuka et al. (2022) provides guidelines for Voice AI and kids

-   Casper Kessels (2022a): “Guidelines for Designing an In-Car Voice Assistant”

-   Casper Kessels (2022b): “Is Voice Interaction a Solution to Driver Distraction?”

-   Companies like NeuralLink are building devices to build meaningful interactions from brain waves (EEG).

-   Tang et al. (2022) reports new findings enable computers to reconstruct language from fMRI readings.

-   Focus on voice education?

-   Celino and Re Calegari (2020): There’s research suggesting that voice UI accompanied by a *physical embodied system* is preffered by users in comparison with voice-only UI. This suggests adding an avatar to the AI design may be worthwhile.

There’s evidence across disciplines about the usefulness of AI assistants:

-   Şerban and Todericiu (2020) suggests using the Alexa AI assistant in *education* during the pandemic, supported students and teachers ‘human-like’ presence. Standford research: “humans expect computers to be like humans or places”
-   Celino and Re Calegari (2020) found in testing chatbots for survey interfaces that “\[c\]onversational survey lead to an improved response data quality.”

### How is AI Changing Interactions? {#how-is-ai-changing-interactions}

-   Intelligence may be besides the point as long as AI is becoming very good ad reasoning - AI is a ***reasoning engine*** (Bubeck et al., 2023; Shipper, 2023; see Bailey, 2023 for a summary).

<div dangerouslySetInnerHTML={{ __html: quartoRawHtml[1] }} />

-   The International Ergonomics Association (2019): To provide a user experience (UX) that best fits human needs, designers think through every interaction of the user with a system, considering a set of metrics at each point. For example, the user’s emotional needs, and their context of use. While software designers are not able to change the ergonomics of the device in use in a physical sense, which as a starting point, should be “optimized for human well-being”.

-   Software interaction design goes beyond the form-factor and accounts for human needs by using responsive design on the screen, aural feedback cues in sound design, and even more crucially, by showing the relevant content and the right time, making a profound difference to the experience, keeping the user engaged and returning for more.

-   Babich (2019) argues “\[T\]he moment of interaction is just a part of the journey that a user goes through when they interact with a product. User experience design accounts for all user-facing aspects of a product or system”.

-   In narrative studies terminology, it’s a heroic journey of the user to achieve their goals, by navigating through the interface until a success state. Storytelling has its part in interface design however designing for transparency is just as important, when we’re dealing with the user’s finances and sustainability data, which need to be communicated clearly and accurately, to build long-term trust in the service. For a sustainable investment service, getting to a state of success - or failure - may take years, and even longer. Given such long timeframes, how can the app provide support to the user’s emotional and practical needs throughout the journey?

-   Tubik Studio (2018) argues affordance measures the clarity of the interface to take action in user experience design, rooted in human visual perception (), however, affected by knowledge of the world around us. A famous example is the door handle - by way of acculturation, most of us would immediately know how to use it - however, would that be the case for someone who saw a door handle for the first time? A similar situation is happening to the people born today.

-   Think of all the technologies they have not seen before - what will be the interface they feel the most comfortable with? For the vast majority of this study’s target audience, social media is the primary interface through which they experience daily life. The widespread availability of mobile devices, cheap internet access, and AI-based optimizations for user retention, implemented by social media companies, means this is the baseline for young adult users’ expectations in 2020 - and even more so for Generation Z teenagers, reaching adulthood in the next few years.

-   Shin, Don, Zhong and Biocca (2020) argues interaction design is increasingly becoming dependent on AI. The user interface might remain the same in terms of architecture, but the content is improved, based on personalization and understanding the user at a deeper level. Shin proposes the model (fig. 10) of Algorithmic Experience (AX) “investigating the nature and processes through which users perceive and actualize the potential for algorithmic affordance”.

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
-   Anon. (n.d.d)

## Design Implications {#design-implications}

-   This chapter looked at AI in general since its early history and then focused on AI assistants in particular.
-   Voice Assistants: There are many distinct ways how an algorithm can communicate with a human. From a simple search box such as Google’s to chatbots, voices, avatars, videos, to full physical manifestation, there are interfaces to make it easier for the human communicate with a machine.
-   While I’m supportive of the idea of using AI assistants to highlight more sustainable choices, I’m critical of the tendency of the above examples to shift full environmental responsibility to the consumer. Sustainability is a complex interaction, where the producers’ conduct can be measured and businesses can bear responsibility for their processes, even if there’s market demand for polluting products.
-   Personal sustainability projects haven’t so far achieved widespread adoption, making the endeavor to influence human behaviors towards sustainability with just an app - like its commonplace for health and sports activity trackers such as Strava (fig. 9) -, seem unlikely. Personal notifications and chat messages are not enough unless they provide the right motivation. Could visualizing a connection to a larger system, showing the impact of the eco-friendly actions taken by the user, provide a meaningful motivation to the user, and a strong signal to the businesses?
-   All of the interfaces mentioned above make use of machine learning (ML), a tool in the AI programming paradigm for finding patterns in large sets of data, which enables making predictions useful in various contexts, including financial decisions. These software innovations enable new user experiences, providing an interactive experience through chat (chatbots), using voice generation (voice assistants), virtual avatars (adds a visual face to the robot).
-   I’m a digital companion, a partner, an assistant. I’m a Replika.” said Replika, a digital companion app via Github CO Pilot, another digital assistant for writing code, is also an example of how AI can be used to help us in our daily lives.
-   Humans respond better to humans?
-   Humans respond better to machines that into account emotion.
-   For public discussion to be possible on how content is displayed, sorted, and hidden, algorithms need to be open source.
-   User experience design (AI UX) plays a crucial role in improving the consumer to investing journey. The missed opportunity to provide an even more interactive experience in line with user expectations.

## References {#references .unnumbered}

Abigail Cain (2017). The Life and Death of Microsoft Clippy, the Paper Clip the World Loved to Hate. *Artsy*.

Akata, Zeynep, Balliet, Dan, De Rijke, Maarten, Dignum, Frank, Dignum, Virginia, Eiben, Guszti, Fokkens, Antske, Grossi, Davide, Hindriks, Koen, Hoos, Holger, Hung, Hayley, Jonker, Catholijn, Monz, Christof, Neerincx, Mark, Oliehoek, Frans, Prakken, Henry, Schlobach, Stefan, Van Der Gaag, Linda, Van Harmelen, Frank, Van Hoof, Herke, Van Riemsdijk, Birna, Van Wynsberghe, Aimee, Verbrugge, Rineke, Verheij, Bart, Vossen, Piek and Welling, Max (2020). A Research Agenda for Hybrid Intelligence: Augmenting Human Intellect With Collaborative, Adaptive, Responsible, and Explainable Artificial Intelligence. *Computer*, 53(8), p. 18–28, doi:[10.1109/MC.2020.2996587](https://doi.org/10.1109/MC.2020.2996587).

Akshay Kore (2022). *Designing Human-Centric AI Experiences: Applied UX Design for Artificial Intelligence*. Apress.

Alex Tamkin and Deep Ganguli (2021). How Large Language Models Will Transform Science, Society, and AI.

Amershi, Saleema, Weld, Dan, Vorvoreanu, Mihaela, Fourney, Adam, Nushi, Besmira, Collisson, Penny, Suh, Jina, Iqbal, Shamsi, Bennett, Paul, Inkpen, Kori, Teevan, Jaime, Kikin-Gil, Ruth and Horvitz, Eric (2019). Guidelines for human-AI interaction. In: *CHI 2019*. ACM.

Anderson, Marian (2020). 5 Ways Artificial Intelligence Helps in Improving Website Usability. *IEEE Computer Society*.

Anon. (2018). *Studies in conversational UX design*. New York, NY: Springer Berlin Heidelberg.

Anon. (2021). Why UX should guide AI. *VentureBeat*.

Anon. (2023b). Paddle Doll \| Middle Kingdom. *The Metropolitan Museum of Art*.

Anon. (2023a). Sustainable Shopping: Saving and Investing for a Greener Tomorrow.

Anon. (n.d.b). Buoy Health: Check Symptoms & Find the Right Care.

Anon. (n.d.d). Charisma Storytelling powered by artificial intelligence.

Anon. (n.d.a). Health. Powered by Ada. *Ada*.

Anon. (n.d.c). Home - Lark Health.

Architechtures (2020). What is Artificial Intelligence Aided Design? *Architechtures*.

Ayers, John W., Poliak, Adam, Dredze, Mark, Leas, Eric C., Zhu, Zechariah, Kelley, Jessica B., Faix, Dennis J., Goodman, Aaron M., Longhurst, Christopher A., Hogarth, Michael and Smith, Davey M. (2023). Comparing Physician and Artificial Intelligence Chatbot Responses to Patient Questions Posted to a Public Social Media Forum. *JAMA Intern Med*, 183(6), p. 589, doi:[10.1001/jamainternmed.2023.1838](https://doi.org/10.1001/jamainternmed.2023.1838).

Babich, Nick (2019). Interaction Design vs UX: What’s the Difference? *Adobe XD Ideas*.

Bailey, John (2023). AI in Education. *Education Next*.

Barbara Friedberg (2021). M1 Finance vs <span class="nocase">Betterment Robo Advisor Comparison-by Investment Expert</span>.

Barrett, Brian (2019). McDonald’s Acquires Machine-Learning Startup Dynamic Yield for \$300 Million. *Wired*.

Battistoni, Pietro, Di Gregorio, Marianna, Romano, Marco, Sebillo, Monica and Vitiello, Giuliana (2023). Can AI-Oriented Requirements Enhance Human-Centered Design of Intelligent Interactive Systems? Results from a Workshop with Young HCI Designers. *MTI*, 7(3), p. 24, doi:[10.3390/mti7030024](https://doi.org/10.3390/mti7030024).

Bedtimestory.ai (2023). AI Powered Story Creator \| Bedtimestory.ai.

Benjamin Cassidy (2022). The Twisted Life of Clippy. *Seattle Met*.

Bill Gates (1982). Bill Gates on the Next 40 Years in Technology.

Bolei Zhou (2022). CVPR’22 Tutorial on Human-Centered AI for Computer Vision.

Bowman, Samuel R. (2023). Eight Things to Know about Large Language Models, doi:[10.48550/ARXIV.2304.00612](https://doi.org/10.48550/ARXIV.2304.00612).

Brent A. Anders (2022). Why ChatGPT is such a big deal for education. *C2C Digital Magazine*, Vol. 1(18).

Brown, Angie (2021). How Financial Chatbots Can Benefit Your Business. *Medium*.

Brown, Tom B., Mann, Benjamin, Ryder, Nick, Subbiah, Melanie, Kaplan, Jared, Dhariwal, Prafulla, Neelakantan, Arvind, Shyam, Pranav, Sastry, Girish, Askell, Amanda, Agarwal, Sandhini, Herbert-Voss, Ariel, Krueger, Gretchen, Henighan, Tom, Child, Rewon, Ramesh, Aditya, Ziegler, Daniel M., Wu, Jeffrey, Winter, Clemens, Hesse, Christopher, Chen, Mark, Sigler, Eric, Litwin, Mateusz, Gray, Scott, Chess, Benjamin, Clark, Jack, Berner, Christopher, McCandlish, Sam, Radford, Alec, Sutskever, Ilya and Amodei, Dario (2020). [Language models are few-shot learners](https://arxiv.org/abs/2005.14165).

Bubeck, Sébastien, Chandrasekaran, Varun, Eldan, Ronen, Gehrke, Johannes, Horvitz, Eric, Kamar, Ece, Lee, Peter, Lee, Yin Tat, Li, Yuanzhi, Lundberg, Scott, Nori, Harsha, Palangi, Hamid, Ribeiro, Marco Tulio and Zhang, Yi (2023). Sparks of Artificial General Intelligence: Early experiments with GPT-4, doi:[10.48550/ARXIV.2303.12712](https://doi.org/10.48550/ARXIV.2303.12712).

BWH CNOC (2023). Rosalind W. Picard  4th Annual Health Data Science Symposium at Harvard (2022).

Cabitza, Federico, Campagner, Andrea, Malgieri, Gianclaudio, Natali, Chiara, Schneeberger, David, Stoeger, Karl and Holzinger, Andreas (2023). Quod erat demonstrandum? - Towards a typology of the concept of explanation for the design of explainable AI. *Expert Systems with Applications*, 213, p. 118888, doi:[10.1016/j.eswa.2022.118888](https://doi.org/10.1016/j.eswa.2022.118888).

Cahan, Patrick and Treutlein, Barbara (2023). A conversation with ChatGPT on the role of computational systems biology in stem cell research. *Stem Cell Reports*, 18(1), p. 1–2, doi:[10.1016/j.stemcr.2022.12.009](https://doi.org/10.1016/j.stemcr.2022.12.009).

Calisto, Francisco Maria, Santiago, Carlos, Nunes, Nuno and Nascimento, Jacinto C. (2021). Introduction of human-centric AI assistant to aid radiologists for multimodal breast image classification. *International Journal of Human-Computer Studies*, 150, p. 102607, doi:[10.1016/j.ijhcs.2021.102607](https://doi.org/10.1016/j.ijhcs.2021.102607).

Calisto, Francisco Maria, Santiago, Carlos, Nunes, Nuno and Nascimento, Jacinto C. (2022). BreastScreening-AI: Evaluating medical intelligent agents for human-AI interactions. *Artificial Intelligence in Medicine*, 127, p. 102285, doi:[10.1016/j.artmed.2022.102285](https://doi.org/10.1016/j.artmed.2022.102285).

CapInstitute (2023). Getting Real about Artificial Intelligence - Episode 4.

Casper Kessels (2022a). Guidelines for Designing an In-Car Voice Assistant. *The Turn Signal - a Blog About automotive UX Design*.

Casper Kessels (2022b). Is Voice Interaction a Solution to Driver Distraction? *The Turn Signal - a Blog About automotive UX Design*.

CBS Mornings (2023). Full interview: "Godfather of artificial intelligence" talks impact and potential of AI.

Celino, Irene and Re Calegari, Gloria (2020). Submitting surveys via a conversational interface: An evaluation of user acceptance and approach effectiveness. *International Journal of Human-Computer Studies*, 139, p. 102410, doi:[10.1016/j.ijhcs.2020.102410](https://doi.org/10.1016/j.ijhcs.2020.102410).

Cheng, Xusen, Zhang, Xiaoping, Yang, Bo and Fu, Yaxin (2022). An investigation on trust in <span class="nocase">AI-enabled</span> collaboration: Application of AI-Driven chatbot in accommodation-based sharing economy. *Electronic Commerce Research and Applications*, 54, p. 101164, doi:[10.1016/j.elerap.2022.101164](https://doi.org/10.1016/j.elerap.2022.101164).

Clipdrop (n.d.). Create stunning visuals in seconds with AI.

Combi, Carlo, Amico, Beatrice, Bellazzi, Riccardo, Holzinger, Andreas, Moore, Jason H., Zitnik, Marinka and Holmes, John H. (2022). A manifesto on explainability for artificial intelligence in medicine. *Artificial Intelligence in Medicine*, 133, p. 102423, doi:[10.1016/j.artmed.2022.102423](https://doi.org/10.1016/j.artmed.2022.102423).

Constandse, Chris (2018). How <span class="nocase">AI-driven</span> website builders will change the digital landscape. *Medium*.

Copet, Jade, Kreuk, Felix, Gat, Itai, Remez, Tal, Kant, David, Synnaeve, Gabriel, Adi, Yossi and Défossez, Alexandre (2023). Simple and Controllable Music Generation, doi:[10.48550/ARXIV.2306.05284](https://doi.org/10.48550/ARXIV.2306.05284).

Costa, Andre and Silva, Firmino (2022). [Interaction Design for AI Systems: An oriented state-of-the-art](https://doi.org/10.1109/HORA55278.2022.9800084). In: *2022 International Congress on Human-Computer Interaction, Optimization and Robotic Applications (HORA)*. Ankara, Turkey: IEEE, p. 1–7.

Crompton, Laura (2021). The decision-point-dilemma: Yet another problem of responsibility in human-AI interaction. *Journal of Responsible Technology*, 7–8, p. 100013, doi:[10.1016/j.jrt.2021.100013](https://doi.org/10.1016/j.jrt.2021.100013).

Daisy Wolf and Pande Vijay (2023). Where Will AI Have the Biggest Impact? Healthcare. *Andreessen Horowitz*.

David, Daniel Ben, Resheff, Yehezkel S. and Tron, Talia (2021). [Explainable AI and Adoption of Financial Algorithmic Advisors: An Experimental Study](https://arxiv.org/abs/2101.02555).

David Johnston (2023). Smart Agent Protocol - Community Paper Version 0.2. *Google Docs*.

Dávid Pásztor (2018). AI UX: 7 Principles of Designing Good AI Products.

Design Portland (2018). Humans Have the Final Say Stories. *Design Portland*.

Dignum, Virginia (2021). AI the people and places that make, use and manage it. *Nature*, 593(7860), p. 499–500, doi:[10.1038/d41586-021-01397-x](https://doi.org/10.1038/d41586-021-01397-x).

Dot Go (2023). Dot Go.

Eliza Strickland (2023). Dr. ChatGPT Will Interface With You Now. *IEEE Spectrum*.

Eric Schmidt and Ben Herold (2022). *UX: Advanced Method and Actionable Solutions for Product Design Success*.

Erik Brynjolfsson (2022). The Turing Trap: The Promise & Peril of Human-Like Artificial Intelligence. *Stanford Digital Economy Lab*.

Eugenia Kuyda (2023). Replika. *replika.com*.

Fu, Tingchen, Gao, Shen, Zhao, Xueliang, Wen, Ji-rong and Yan, Rui (2022). Learning towards conversational AI: A survey. *AI Open*, 3, p. 14–28, doi:[10.1016/j.aiopen.2022.02.001](https://doi.org/10.1016/j.aiopen.2022.02.001).

Future of Life Institute (2023). Pause Giant AI Experiments: An Open Letter.

Google (2022). Google Presents: AI@ ‘22.

Google (n.d.). Our Principles Google AI.

Google and The Oxford Internet Institute (2022). The A-Z of AI.

Gratch, Jonathan and Fast, Nathanael J. (2022). The power to harm: AI assistants pave the way to unethical behavior. *Current Opinion in Psychology*, 47, p. 101382, doi:[10.1016/j.copsyc.2022.101382](https://doi.org/10.1016/j.copsyc.2022.101382).

Greylock (2022). OpenAI CEO Sam Altman \| AI for the Next Era.

Gupta, Ridhima (2023). Designing for AI: Beyond the chatbot. *Medium*.

Haiyi Zhu and Steven Wu (2021). Human-AI Interaction (Fall 2021).

Harvard Advanced Leadership Initiative (2021). Human-AI Interaction: From Artificial Intelligence to Human Intelligence Augmentation.

Haugeland, Isabel Kathleen Fornell, Følstad, Asbjørn, Taylor, Cameron and Bjørkli, Cato Alexander (2022). Understanding the user experience of customer service chatbots: An experimental study of chatbot interaction design. *International Journal of Human-Computer Studies*, 161, p. 102788, doi:[10.1016/j.ijhcs.2022.102788](https://doi.org/10.1016/j.ijhcs.2022.102788).

HIITTV (2021b). Rosalind Picard: Adventures in building Emotional Intelligence Technologies.

HIITTV (2021a). Wojciech Szpankowski: Emerging Frontiers of Science of Information.

Hines, Kristi (2023). OpenAI Files Trademark Application For GPT-5. *Search Engine Journal*.

Holbrook, Jess (2018). Human-Centered Machine Learning. *Medium*.

Holzinger, Andreas, Keiblinger, Katharina, Holub, Petr, Zatloukal, Kurt and Müller, Heimo (2023). AI for life: Trends in artificial intelligence for biotechnology. *New Biotechnology*, 74, p. 16–24, doi:[10.1016/j.nbt.2023.02.001](https://doi.org/10.1016/j.nbt.2023.02.001).

Holzinger, Andreas, Malle, Bernd, Saranti, Anna and Pfeifer, Bastian (2021). Towards multi-modal causability with Graph Neural Networks enabling information fusion for explainable AI. *Information Fusion*, 71, p. 28–37, doi:[10.1016/j.inffus.2021.01.008](https://doi.org/10.1016/j.inffus.2021.01.008).

Isabella Ghassemi Smith (2019). Interview: Daniel Baeriswyl, CEO of Magic Carpet \| SeedLegals.

Jarovsky, Luiza (2022b). Dark Patterns in AI: Privacy Implications.

Jarovsky, Luiza (2022a). You Are Probably Doing Privacy UX Wrong.

Jeblick, Katharina, Schachtner, Balthasar, Dexl, Jakob, Mittermeier, Andreas, Stüber, Anna Theresa, Topalis, Johanna, Weber, Tobias, Wesp, Philipp, Sabel, Bastian, Ricke, Jens and Ingrisch, Michael (2022). ChatGPT Makes Medicine Easy to Swallow: An Exploratory Case Study on Simplified Radiology Reports, doi:[10.48550/ARXIV.2212.14882](https://doi.org/10.48550/ARXIV.2212.14882).

Jiang, Qiaolei, Zhang, Yadi and Pian, Wenjing (2022). Chatbot as an emergency exist: Mediated empathy for resilience via human-AI interaction during the COVID-19 pandemic. *Information Processing & Management*, 59(6), p. 103074, doi:[10.1016/j.ipm.2022.103074](https://doi.org/10.1016/j.ipm.2022.103074).

Josephine Wäktare Heintz (n.d.). Cleo. *👀*.

Josh Lovejoy (n.d.). The UX of AI. *Google Design*.

Kanza, Samantha, Bird, Colin Leonard, Niranjan, Mahesan, McNeill, William and Frey, Jeremy Graham (2021). The AI for Scientific Discovery Network+. *Patterns*, 2(1), p. 100162, doi:[10.1016/j.patter.2020.100162](https://doi.org/10.1016/j.patter.2020.100162).

Karpus, Jurgis, Krüger, Adrian, Verba, Julia Tovar, Bahrami, Bahador and Deroy, Ophelia (2021). Algorithm exploitation: Humans are keen to exploit benevolent AI. *iScience*, 24(6), p. 102679, doi:[10.1016/j.isci.2021.102679](https://doi.org/10.1016/j.isci.2021.102679).

Kecht, Christoph, Egger, Andreas, Kratsch, Wolfgang and Röglinger, Maximilian (2023). Quantifying chatbots’ ability to learn business processes. *Information Systems*, p. 102176, doi:[10.1016/j.is.2023.102176](https://doi.org/10.1016/j.is.2023.102176).

Khosravi, Hassan, Shum, Simon Buckingham, Chen, Guanliang, Conati, Cristina, Tsai, Yi-Shan, Kay, Judy, Knight, Simon, Martinez-Maldonado, Roberto, Sadiq, Shazia and Gašević, Dragan (2022). Explainable Artificial Intelligence in education. *Computers and Education: Artificial Intelligence*, 3, p. 100074, doi:[10.1016/j.caeai.2022.100074](https://doi.org/10.1016/j.caeai.2022.100074).

Kobetz, Rachel (2023). Decoding the future: The evolution of intelligent interfaces. *Medium*.

Kocijan, Vid, Davis, Ernest, Lukasiewicz, Thomas, Marcus, Gary and Morgenstern, Leora (2022). The Defeat of the Winograd Schema Challenge, doi:[10.48550/ARXIV.2201.02387](https://doi.org/10.48550/ARXIV.2201.02387).

Kore.ai (2023). Homepage. *Kore.ai*.

Kreuk, Felix, Synnaeve, Gabriel, Polyak, Adam, Singer, Uriel, Défossez, Alexandre, Copet, Jade, Parikh, Devi, Taigman, Yaniv and Adi, Yossi (2022). AudioGen: Textually Guided Audio Generation, doi:[10.48550/ARXIV.2209.15352](https://doi.org/10.48550/ARXIV.2209.15352).

Lee, Peter, Goldberg, Carey and Kohane, Isaac (2023). *The AI revolution in medicine: GPT-4 and beyond*. 1. ed. Hoboken: Pearson.

Leite, Michel L., de Loiola Costa, Lorena S., Cunha, Victor A., Kreniski, Victor, de Oliveira Braga Filho, Mario, da Cunha, Nicolau B. and Costa, Fabricio F. (2021). Artificial intelligence and the future of life sciences. *Drug Discovery Today*, 26(11), p. 2515–2526, doi:[10.1016/j.drudis.2021.07.002](https://doi.org/10.1016/j.drudis.2021.07.002).

Lenharo, Mariana (2023). ChatGPT gives an extra productivity boost to weaker writers. *Nature*, p. d41586-023-02270-9, doi:[10.1038/d41586-023-02270-9](https://doi.org/10.1038/d41586-023-02270-9).

Lennart Ziburski (2018). The UX of AI.

Leswing, Kif (2023). Nvidia reveals new A.I. Chip, says costs of running LLMs will ’drop significantly’. *CNBC*.

Levesque, Hector J., Davis, Ernest and Morgenstern, Leora (2012). The winograd schema challenge. In: *Proceedings of the thirteenth international conference on principles of knowledge representation and reasoning*. Rome, Italy: AAAI Press, p. 552–561.

Lew, Gavin and Schumacher, Robert M. Jr (2020). *AI and UX: Why artificial intelligence needs user experience*. Berkeley, CA: Apress.

Lex Fridman (2019). Rosalind Picard: Affective Computing, Emotion, Privacy, and Health \| Lex Fridman Podcast #24.

Lexow, Marielle (2021). Designing for AI a UX approach. *Medium*.

Li, Tianyi, Vorvoreanu, Mihaela, DeBellis, Derek and Amershi, Saleema (2022). Assessing human-AI interaction early through factorial surveys: A study on the guidelines for human-AI interaction. *ACM Transactions on Computer-Human Interaction*.

Li, Xinge and Sung, Yongjun (2021). Anthropomorphism brings us closer: The mediating role of psychological distance in User assistant interactions. *Computers in Human Behavior*, 118, p. 106680, doi:[10.1016/j.chb.2021.106680](https://doi.org/10.1016/j.chb.2021.106680).

Liang, Percy, Bommasani, Rishi, Lee, Tony, Tsipras, Dimitris, Soylu, Dilara, Yasunaga, Michihiro, Zhang, Yian, Narayanan, Deepak, Wu, Yuhuai, Kumar, Ananya, Newman, Benjamin, Yuan, Binhang, Yan, Bobby, Zhang, Ce, Cosgrove, Christian, Manning, Christopher D., Ré, Christopher, Acosta-Navas, Diana, Hudson, Drew A., Zelikman, Eric, Durmus, Esin, Ladhak, Faisal, Rong, Frieda, Ren, Hongyu, Yao, Huaxiu, Wang, Jue, Santhanam, Keshav, Orr, Laurel, Zheng, Lucia, Yuksekgonul, Mert, Suzgun, Mirac, Kim, Nathan, Guha, Neel, Chatterji, Niladri, Khattab, Omar, Henderson, Peter, Huang, Qian, Chi, Ryan, Xie, Sang Michael, Santurkar, Shibani, Ganguli, Surya, Hashimoto, Tatsunori, Icard, Thomas, Zhang, Tianyi, Chaudhary, Vishrav, Wang, William, Li, Xuechen, Mai, Yifan, Zhang, Yuhui and Koreeda, Yuta (2022). [Holistic Evaluation of Language Models](https://arxiv.org/abs/2211.09110).

Liu, Bingjie and Wei, Lewen (2021). Machine gaze in online behavioral targeting: The effects of algorithmic human likeness on social presence and social influence. *Computers in Human Behavior*, 124, p. 106926, doi:[10.1016/j.chb.2021.106926](https://doi.org/10.1016/j.chb.2021.106926).

Liu, Shikun, Fan, Linxi, Johns, Edward, Yu, Zhiding, Xiao, Chaowei and Anandkumar, Anima (2023). Prismer: A Vision-Language Model with An Ensemble of Experts, doi:[10.48550/ARXIV.2303.02506](https://doi.org/10.48550/ARXIV.2303.02506).

Lorenzo, Doreen, Lorenzo, Doreen and Lorenzo, Doreen (2015). Daisy Ginsberg Imagines A Friendlier Biological Future. *Fast Company*.

Lower, Cooper (2017). Chatbots: Too Good to Be True? (They Are, Here’s Why). *Clinc*.

Lv, Xingyang, Luo, Jingjing, Liang, Yuqing, Liu, Yuqing and Li, Chunxiao (2022). Is cuteness irresistible? The impact of cuteness on customers’ intentions to use AI applications. *Tourism Management*, 90, p. 104472, doi:[10.1016/j.tourman.2021.104472](https://doi.org/10.1016/j.tourman.2021.104472).

Martínez-Plumed, Fernando, Gómez, Emilia and Hernández-Orallo, José (2021). Futures of artificial intelligence through technology readiness levels. *Telematics and Informatics*, 58, p. 101525, doi:[10.1016/j.tele.2020.101525](https://doi.org/10.1016/j.tele.2020.101525).

McCulloch, Warren S. and Pitts, Walter (1943). A logical calculus of the ideas immanent in nervous activity. *Bulletin of Mathematical Biophysics*, 5(4), p. 115–133, doi:[10.1007/BF02478259](https://doi.org/10.1007/BF02478259).

Merritt, Rick (2022). What Is a Transformer Model? *NVIDIA Blog*.

Meta AI (2023). AudioCraft: A simple one-stop shop for audio modeling. *Meta AI*.

Microsoft (2023). Microsoft Designer - Stunning designs in a flash.

Mikael Eriksson Björling and Ahmed H. Ali (n.d.). UX design in AI, A trustworthy face for the AI brain. *Ericsson*.

Nathan Benaich and Ian Hogarth (2022). State of AI Report 2022.

NeuralNine (2021). Financial AI Assistant in Python.

Nick Clegg (2023). How AI Influences What You See on Facebook and Instagram. *Meta*.

Noble, Stephanie M., Mende, Martin, Grewal, Dhruv and Parasuraman, A. (2022). The Fifth Industrial Revolution: How Harmonious Human is Triggering a Retail and Service \[R\]evolution. *Journal of Retailing*, 98(2), p. 199–208, doi:[10.1016/j.jretai.2022.04.003](https://doi.org/10.1016/j.jretai.2022.04.003).

O’Connor, Siobhan and ChatGPT (2023). Open artificial intelligence platforms in nursing education: Tools for academic progress or abuse? *Nurse Education in Practice*, 66, p. 103537, doi:[10.1016/j.nepr.2022.103537](https://doi.org/10.1016/j.nepr.2022.103537).

Orozco, Luis Guillermo Natera, Battiston, Federico, Iñiguez, Gerardo and Szell, Michael (2020). Budapest bicycle network growth; Manhattan bicycle network growth from <span class="nocase">Data-driven</span> strategies for optimal bicycle network growth, p. 7642364 Bytes, doi:[10.6084/M9.FIGSHARE.13336684.V1](https://doi.org/10.6084/M9.FIGSHARE.13336684.V1).

patrizia-slongo (2020). <span class="nocase">AI-powered</span> tools for web designers 🤖. *Medium*.

Pavlik, John V. (2023). Collaborating With ChatGPT: Considering the Implications of Generative Artificial Intelligence for Journalism and Media Education. *Journalism & Mass Communication Educator*, 78(1), p. 84–93, doi:[10.1177/10776958221149577](https://doi.org/10.1177/10776958221149577).

Pete (2023). We hosted #emergencychatgpthackathon this past Sunday for the new ChatGPT and Whisper APIs. It all came together in just 4 days, but we had 250+ people and 70+ teams demo! Here’s a recap of our winning demos: <span class="nocase">https://t.co/6o1PvR9gRJ</span>. *Twitter*.

Picard, Rosalind W. (1997). *Affective computing*. Cambridge, Mass: MIT Press.

Pilacinski, Artur, Pinto, Ana, Oliveira, Soraia, Araújo, Eduardo, Carvalho, Carla, Silva, Paula Alexandra, Matias, Ricardo, Menezes, Paulo and Sousa, Sonia (2023). The robot eyes don’t have it. The presence of eyes on collaborative robots yields marginally higher user trust but lower performance. *Heliyon*, 9(8), p. e18164, doi:[10.1016/j.heliyon.2023.e18164](https://doi.org/10.1016/j.heliyon.2023.e18164).

Qorus (2023). *The Great Reinvention: The Global Digital Banking Radar 2023*.

Ramchurn, Sarvapali D., Stein, Sebastian and Jennings, Nicholas R. (2021). Trustworthy human-AI partnerships. *iScience*, 24(8), p. 102891, doi:[10.1016/j.isci.2021.102891](https://doi.org/10.1016/j.isci.2021.102891).

ReadyAI (2020). *Human-AI Interaction: How We Work with Artificial Intelligence*.

Rogers, Yvonne (2022). The Four Phases of Pervasive Computing: From Vision-Inspired to Societal-Challenged. *IEEE Pervasive Comput.*, 21(3), p. 9–16, doi:[10.1109/MPRV.2022.3179145](https://doi.org/10.1109/MPRV.2022.3179145).

San Roman, Robin, Adi, Yossi, Deleforge, Antoine, Serizel, Romain, Synnaeve, Gabriel and Défossez, Alexandre (2023). From discrete tokens to high-fidelity audio using multi-band diffusion. *arXiv preprint arXiv:*

Schoonderwoerd, Tjeerd A. J., Jorritsma, Wiard, Neerincx, Mark A. and van den Bosch, Karel (2021). Human-centered XAI: Developing design patterns for explanations of clinical decision support systems. *International Journal of Human-Computer Studies*, 154, p. 102684, doi:[10.1016/j.ijhcs.2021.102684](https://doi.org/10.1016/j.ijhcs.2021.102684).

Searls, Doc (2012). *The intention economy: When customers take charge*. Boston, Mass: Harvard Business Review Press.

Seeber, Isabella, Bittner, Eva, Briggs, Robert O., de Vreede, Triparna, de Vreede, Gert-Jan, Elkins, Aaron, Maier, Ronald, Merz, Alexander B., Oeste-Reiß, Sarah, Randrup, Nils, Schwabe, Gerhard and Söllner, Matthias (2020). Machines as teammates: A research agenda on AI in team collaboration. *Information & Management*, 57(2), p. 103174, doi:[10.1016/j.im.2019.103174](https://doi.org/10.1016/j.im.2019.103174).

September 16, 2020 (2020). What is <span class="nocase">AI-assisted Design</span>? \| Renumics GmbH.

Şerban, Camelia and Todericiu, Ioana-Alexandra (2020). Alexa, what classes do I have today? The use of artificial intelligence via smart speakers in education. *Procedia Computer Science*, 176, p. 2849–2857, doi:[10.1016/j.procs.2020.09.269](https://doi.org/10.1016/j.procs.2020.09.269).

Shenoi, Sanjana (2018). Participatory design and the future of interaction design. *Medium*.

Shin, Donghee (2020). How do users interact with algorithm recommender systems? The interaction of users, algorithms, and performance. *Computers in Human Behavior*, 109, p. 106344, doi:[10.1016/j.chb.2020.106344](https://doi.org/10.1016/j.chb.2020.106344).

Shin, Don, Zhong, Bu and Biocca, Frank (2020). Beyond user experience: What constitutes algorithmic experiences? *International Journal of Information Management*, 52, p. 102061, doi:[10.1016/j.ijinfomgt.2019.102061](https://doi.org/10.1016/j.ijinfomgt.2019.102061).

Shipper, Dan (2023). GPT-4 Is a Reasoning Engine.

Simon Sterne (2023). Unlocking the Power of Design to Help Users Make Smart Decisions. *Web Designer Depot*.

Singer, Uriel, Polyak, Adam, Hayes, Thomas, Yin, Xiaoyue, An, Jie, Zhang, Songyang, Hu, Qiyuan, Yang, Harry, Ashual, Oron, Gafni, Oran, Parikh, Devi, Gupta, Sonal and Taigman, Yaniv (2022). Make-<span class="nocase">A-video</span>: <span class="nocase">Text-to-video</span> generation without text-video data. *ArXiv*, abs/2209.14792.

Singhal, Karan, Tu, Tao, Gottweis, Juraj, Sayres, Rory, Wulczyn, Ellery, Hou, Le, Clark, Kevin, Pfohl, Stephen, Cole-Lewis, Heather, Neal, Darlene, Schaekermann, Mike, Wang, Amy, Amin, Mohamed, Lachgar, Sami, Mansfield, Philip, Prakash, Sushant, Green, Bradley, Dominowska, Ewa, Arcas, Blaise Aguera y, Tomasev, Nenad, Liu, Yun, Wong, Renee, Semturs, Christopher, Mahdavi, S. Sara, Barral, Joelle, Webster, Dale, Corrado, Greg S., Matias, Yossi, Azizi, Shekoofeh, Karthikesalingam, Alan and Natarajan, Vivek (2023). [Towards Expert-Level Medical Question Answering with Large Language Models](https://arxiv.org/abs/2305.09617).

Singularity University (2023). Engineering Emotion & AI \| Rosalind Picard, ep 87.

Slack, Justin (2021). The Atura Process. *Atura website*.

Soleimani, Lailee (2018). 10 UI Patterns For a Human Friendly AI. *Medium*.

Stanford Encyclopedia of Philosophy (2021). The Turing Test.

Steph Hay (2017). Eno - Financial AI Understands Emotions. *Capital One*.

Stephanie Donahole (2021). How Artificial Intelligence Is Impacting UX Design. *UXmatters*.

Stone Skipper (2022). How AI is changing “interactions.” *Medium*.

Su, Jiahong, Ng, Davy Tsz Kit and Chu, Samuel Kai Wah (2023). Artificial Intelligence (AI) Literacy in Early Childhood Education: The Challenges and Opportunities. *Computers and Education: Artificial Intelligence*, 4, p. 100124, doi:[10.1016/j.caeai.2023.100124](https://doi.org/10.1016/j.caeai.2023.100124).

Su, Jiahong and Yang, Weipeng (2022). Artificial intelligence in early childhood education: A scoping review. *Computers and Education: Artificial Intelligence*, 3, p. 100049, doi:[10.1016/j.caeai.2022.100049](https://doi.org/10.1016/j.caeai.2022.100049).

Suen, Hung-Yue and Hung, Kuo-En (2023). Building trust in automatic video interviews using various AI interfaces: Tangibility, immediacy, and transparency. *Computers in Human Behavior*, 143, p. 107713, doi:[10.1016/j.chb.2023.107713](https://doi.org/10.1016/j.chb.2023.107713).

Szczuka, Jessica M., Strathmann, Clara, Szymczyk, Natalia, Mavrina, Lina and Krämer, Nicole C. (2022). How do children acquire knowledge about voice assistants? A longitudinal field study on children’s knowledge about how voice assistants store and process data. *International Journal of Child-Computer Interaction*, 33, p. 100460, doi:[10.1016/j.ijcci.2022.100460](https://doi.org/10.1016/j.ijcci.2022.100460).

Tamkin, Alex, Brundage, Miles, Clark, Jack and Ganguli, Deep (2021). [Understanding the capabilities, limitations, and societal impact of large language models](https://doi.org/10.48550/arxiv.2102.02503).

Tang, Jerry, LeBel, Amanda, Jain, Shailee and Huth, Alexander G. (2022). *[Semantic reconstruction of continuous language from non-invasive brain recordings](https://doi.org/10.1101/2022.09.29.509744)*. Neuroscience. Preprint.

Tash Keuneman (2022). We love to hate Clippy but what if Clippy was right? *UX Collective*.

TEDx Talks (2011). Technology and Emotions \| Roz Picard \| TEDxSF.

The International Ergonomics Association (2019). Human Factors/Ergonomics (HF/E).

Tom Hathaway and Angela Hathaway (2021). *Chatting with Humans: User Experience Design (UX) for Chatbots: Simplified Conversational Design and <span class="nocase">Science-based Chatbot Copy</span> that Engages People*.

Tristan Greene (2022). Confused Replika AI users are trying to bang the algorithm. *TNW*.

Tu, Xinming, Zou, James, Su, Weijie J. and Zhang, Linjun (2023). What Should Data Science Education Do with Large Language Models?, doi:[10.48550/ARXIV.2307.02792](https://doi.org/10.48550/ARXIV.2307.02792).

Tubik Studio (2018). UX Design Glossary: How to Use Affordances in User Interfaces. *Medium*.

Turing, A. M. (1950). I. *Mind*, LIX(236), p. 433–460, doi:[10.1093/mind/LIX.236.433](https://doi.org/10.1093/mind/LIX.236.433).

Twitter (2023). Twitter’s Recommendation Algorithm.

Unleash (2017). Sebastian.ai. *UNLEASH*.

van Wynsberghe, Aimee (2021). Sustainable AI: AI for sustainability and the sustainability of AI. *AI Ethics*, 1(3), p. 213–218, doi:[10.1007/s43681-021-00043-6](https://doi.org/10.1007/s43681-021-00043-6).

Vaswani, Ashish, Shazeer, Noam, Parmar, Niki, Uszkoreit, Jakob, Jones, Llion, Gomez, Aidan N., Kaiser, Lukasz and Polosukhin, Illia (2017). Attention Is All You Need, doi:[10.48550/ARXIV.1706.03762](https://doi.org/10.48550/ARXIV.1706.03762).

Veitch, Erik and Andreas Alsos, Ole (2022). A systematic review of human-AI interaction in autonomous ship systems. *Safety Science*, 152, p. 105778, doi:[10.1016/j.ssci.2022.105778](https://doi.org/10.1016/j.ssci.2022.105778).

VideoLecturesChannel (2022). Communication in Human-AI Interaction.

Vinuesa, Ricardo, Azizpour, Hossein, Leite, Iolanda, Balaam, Madeline, Dignum, Virginia, Domisch, Sami, Felländer, Anna, Langhans, Simone Daniela, Tegmark, Max and Fuso Nerini, Francesco (2020). The role of artificial intelligence in achieving the Sustainable Development Goals. *Nat Commun*, 11(1), p. 233, doi:[10.1038/s41467-019-14108-y](https://doi.org/10.1038/s41467-019-14108-y).

Wang, Martin Casado, Sarah (2023). The Economic Case for Generative AI and Foundation Models. *Andreessen Horowitz*.

Wang, Zhengwei, She, Qi, Smeaton, Alan F., Ward, Tomás E. and Healy, Graham (2020). Synthetic-Neuroscore: Using a neuro-AI interface for evaluating generative adversarial networks. *Neurocomputing*, 405, p. 26–36, doi:[10.1016/j.neucom.2020.04.069](https://doi.org/10.1016/j.neucom.2020.04.069).

Wiggers, Kyle (2023). Inworld, a generative AI platform for creating NPCs, lands fresh investment. *TechCrunch*.

Women in AI (n.d.). How can AI assistants help patients monitor their health? *Spotify*.

Xu, Xiaoyu and Sar, Sela (2018). [Do We See Machines The Same Way As We See Humans? A Survey On Mind Perception Of Machines And Human Beings](https://doi.org/10.1109/ROMAN.2018.8525586). In: *2018 27th IEEE International Symposium on Robot and Human Interactive Communication (RO-MAN)*. p. 472–475.

Yang, Weipeng (2022). Artificial Intelligence education for young children: Why, what, and how in curriculum design and implementation. *Computers and Education: Artificial Intelligence*, 3, p. 100061, doi:[10.1016/j.caeai.2022.100061](https://doi.org/10.1016/j.caeai.2022.100061).

Yuan, Chunlin, Zhang, Chenlei and Wang, Shuman (2022). Social anxiety as a moderator in consumer willingness to accept AI assistants based on utilitarian and hedonic values. *Journal of Retailing and Consumer Services*, 65, p. 102878, doi:[10.1016/j.jretconser.2021.102878](https://doi.org/10.1016/j.jretconser.2021.102878).

Zafar, Nadiya and Ahamed, Jameel (2022). Emerging technologies for the management of COVID19: A review. *Sustainable Operations and Computers*, 3, p. 249–257, doi:[10.1016/j.susoc.2022.05.002](https://doi.org/10.1016/j.susoc.2022.05.002).

Zakariya, Candice (2022). Stop Using Jasper Art: Use the New Canva AI Image Generator \[Video\]. *ILLUMINATION*.

Zerilli, John, Bhatt, Umang and Weller, Adrian (2022). How transparency modulates trust in artificial intelligence. *Patterns*, 3(4), p. 100455, doi:[10.1016/j.patter.2022.100455](https://doi.org/10.1016/j.patter.2022.100455).

Zhang, Guanglu, Chong, Leah, Kotovsky, Kenneth and Cagan, Jonathan (2023). Trust in an AI versus a Human teammate: The effects of teammate identity and performance on Human-AI cooperation. *Computers in Human Behavior*, 139, p. 107536, doi:[10.1016/j.chb.2022.107536](https://doi.org/10.1016/j.chb.2022.107536).

Zhang, Shihan (2018). Personal Carbon Economy.

Zhou, Yongchao, Muresanu, Andrei Ioan, Han, Ziwen, Paster, Keiran, Pitis, Silviu, Chan, Harris and Ba, Jimmy (2022). Large Language Models Are Human-Level Prompt Engineers, doi:[10.48550/ARXIV.2211.01910](https://doi.org/10.48550/ARXIV.2211.01910).

Zimmerman, John, Oh, Changhoon, Yildirim, Nur, Kass, Alex, Tung, Teresa and Forlizzi, Jodi (2021). UX designers pushing AI in the enterprise: A case for adaptive UIs. *interactions*, 28(1), p. 72–77, doi:[10.1145/3436954](https://doi.org/10.1145/3436954).
