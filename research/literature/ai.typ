// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): block.with(
    fill: luma(230), 
    width: 100%, 
    inset: 8pt, 
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    new_title_block +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}



#let article(
  title: none,
  authors: none,
  date: none,
  abstract: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: (),
  fontsize: 11pt,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)

  if title != none {
    align(center)[#block(inset: 2em)[
      #text(weight: "bold", size: 1.5em)[#title]
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[Abstract] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#set table(
  inset: 6pt,
  stroke: none
)
#show: doc => article(
  title: [A.I.],
  toc_title: [Table of contents],
  toc_depth: 3,
  cols: 1,
  doc,
)


= Human Patterns Enable Computers to Become AIs
<human-patterns-enable-computers-to-become-ais>
The fact that AI systems work so well is proof that we live in a measurable world. There world is filled with structures. Nature, cultures, languages, human interactions, all form intricate patterns. Computer systems are becoming increasingly powerful in their ability copy these patterns into computer models - known as machine learning. As of 2023, 97 zettabytes (and growing) of data was created in the world per year @soundaryajayaramanHowBigBig2023. Big data is a basic requirement for training AIs, enabling learning from the structures of the world with increasing accuracy. Representations of the real world in digital models enable humans to ask questions about the real-world structures and to manipulate them to create synthetic experiments that may match the real world (if the model is accurate enough). This can be used for generating human-sounding language and realistic images, finding mechanisms for novel medicines as well as understanding the fundamental functioning of life on its deep physical and chemical level @nopriorsInceptiveCEOJakob2023.

Already ninety years ago @mccullochLogicalCalculusIdeas1943 proposed the first mathematical model of a neural network inspired by the human brain. Alan Turing’s Test for Machine Intelligence followed in 1950. Turing’s initial idea was to design a game of imitation to test human-computer interaction using text messages between a human and 2 other participants, one of which was a human, and the other - a computer. The question was, if the human was simultaneously speaking to another human and a machine, could the messages from the machine be clearly distinguished or would they resemble a human being so much, that the person asking questions would be deceived, unable to realize which one is the human and which one is the machine? @turingCOMPUTINGMACHINERYINTELLIGENCE1950.

#quote(block: true)[
Alan Turing: #emph["I believe that in about fifty years’ time it will be possible to program computers, with a storage capacity of about 10#super[9];, to make them play the imitation game so well that an average interrogator will not have more than 70 percent chance of making the right identification after five minutes of questioning. … I believe that at the end of the century the use of words and general educated opinion will have altered so much that one will be able to speak of machines thinking without expecting to be contradicted."] - from @stanfordencyclopediaofphilosophyTuringTest2021
]

By the 2010s AI models became capable enough to beat humans in games of Go and Chess, yet they did not yet pass the Turing test. AI use was limited to specific tasks. While over the years, the field of AI had seen a long process of incremental improvements, developing increasingly advanced models of decision-making, it took an #strong[#emph[increase in computing power];] and an approach called #strong[#emph[deep learning];];, a variation of #strong[#emph[machine learning (1980s),];] largely modeled after the #strong[#emph[neural networks];] of the biological (human) brain, returning to the idea of #strong[#emph[biomimicry];];, inspired by nature, building a machine to resemble the connections between neurons, but digitally, on layers much deeper than attempted before.

=== Reinforcement Learning with Human Feedback (RLHF)
<reinforcement-learning-with-human-feedback-rlhf>
Combining deep learning with reinforcement learning and reinforcement learning with human feedback (RLHF) enabled AI to achieve intelligence to beat the Turing test @karamankeChatGPTArchitectBerkeley2022@christianoMyResearchMethodology2021@christianoDeepReinforcementLearning2017. OpenAI co-founder John Schulman describes RLHF: "the models are just trained to produce a single message that gets high approval from a human reader" @karamankeChatGPTArchitectBerkeley2022.

The nature-inspired approach was successful. Innovations such as #strong[#emph[back-propagation];];for reducing errors through updating model weights and #strong[#emph[transformers];] for tracking relationships in sequential data (for example sentences), AI models became increasingly capable @vaswaniAttentionAllYou2017@merrittWhatTransformerModel2022. Generative Adversarial Networks\*\*\* (GAN), (#strong[ADD CITATION, 2016];), and #strong[#emph[Large Language Models (];ADD CITATION#emph[, 2018)];];, enabled increasingly generalized models, capable of more complex tasks, such as language generation. One of the leading scientists in this field of research, Geoffrey Hinton, had attempted back-propagation already in the 1980s and reminiscents how "the only reason neural networks didn’t work in the 1980s was because we didn’t have have enough data and we didn’t have enough computing power" @cbsmorningsFullInterviewGodfather2023.

- How do transformers work? Illustration #cite(<alammarIllustratedTransformer2018>, form: "prose")

By the 2020s, AI-based models became a mainstay in medical research, drug development, patient care @LEITE20212515@holzingerAILifeTrends2023, quickly finding potential vaccine candidates during the COVID19 pandemic @ZAFAR2022249, self-driving vehicles, including cars, delivery robots, drones in the sea and air, as well as AI-based assistants. The existence of AI models has wide implications for all human activities from personal to professional. The founder of the largest chimp-maker NVIDIA calls upon all countries do develop their own AI-models which would encode their local knowledge, culture, and language to make sure these are accurately captured @worldgovernmentssummitConversationFounderNVIDIA2024.

OpenAI has researched a wide range of approaches towards artificial general intelligence (AGI), work which has led to advances in large language models@ilyasutskeverIlyaSutskeverAI2018@aifrontiersIlyaSutskeverAI2018. In 2020 OpenAI released a LLM called GPT-3 trained on 570 GB of text @alextamkinHowLargeLanguage2021 which was adept in text-generation. @Singer2022MakeAVideoTG describes how collecting billions of images with descriptive data (for example the descriptive #emph[alt] text which accompanies images on websites) enabled researchers to train AI models such as #strong[#emph[stable diffusion];] for image-generation based on human-language. These training make use of #strong[#emph[Deep Learning];];, a layered approach to AI training, where increasing depth of the computer model captures minute details of the world. Much is still to be understood about how deep learning works; the fractal structure of deep learning can only be called mysterious @sohl-dicksteinBoundaryNeuralNetwork2024.

Hinton likes to call AI an #emph[idiot savant];: someone with exceptional aptitude yet serious mental disorder @cbsmorningsFullInterviewGodfather2023. Large AI models don’t understand the world like humans do. Their responses are predictions based on their training data and complex statistics. Indeed, the comparison may be apt, as the AI field now offers jobs for #emph[AI psychologists (ADD CITATION)];, whose role is to figure out what exactly is happening inside the 'AI brain'. Understading the insides of AI models trained of massive amounts of data is important because they are #strong[#emph[foundational];];, enabling a holistic approach to learning, combining many disciplines using languages, instead of the reductionist way we as human think because of our limitations @capinstituteGettingRealArtificial2023.

Standford "thorough account of the opportunities and risks of foundation models" @bommasaniOpportunitiesRisksFoundation2021.

Foundational AI models enable #strong[#emph[generative AIs];];, a class of AI models which are able to generate many types of #strong[#emph[tokens,];] such as text, speech, audio @sanroman2023fromdi@kreukAudioGenTextuallyGuided2022, music @copetSimpleControllableMusic2023@metaaiAudioCraftSimpleOnestop2023 and video, in any language it’s trained on. Even complex structures such 3D models and even genomes are possible to generate. Generative AI is a revolution in human-AI interaction as AI models became increasingly capable of producing human-like content which is hard to separate from actual human creations. This power comes with #strong[#emph[increased need for responsibility];];, drawing growing interest in fields like #strong[#emph[AI ethics];] and #strong[#emph[AI explainability.];] Generative has a potential for misuse, as humans are increasingly confused by what is computer-generated and what is human-created, unable to distinguish one from the other with certainty.

@nobleFifthIndustrialRevolution2022 proposes AI has reached a stage of development marking beginning of the #strong[#emph[5th industrial revolution];];, a time of collaboration between humans and AI. Widespread #strong[Internet of Things (IoT)] sensor networks that gather data analyzed by AI algorithms, integrates computing even deeper into the fabric of daily human existence. Several terms of different origin but considerable overlap describe this phenomenon, including #strong[#emph[Pervasive Computing (PC)];] @rogersFourPhasesPervasive2022 and #strong[#emph[Ubiquitous Computing];];. Similar concepts are #strong[#emph[Ambient Computing];];, which focuses more on the invisibility of technology, fading into the background, without us, humans, even noticing it, and #strong[#emph[Calm Technology];];, which highlights how technology respects humans and our limited attention spans, and doesn’t call attention to itself. In all cases, AI is integral part of our everyday life, inside everything and everywhere. Today AI is not an academic concept but a mainstream reality, affecting our daily lives everywhere, even when we don’t notice it.

== Human-in-the-Loop (HITL)
<human-in-the-loop-hitl>
AI responses are probabilistic and need some function for ranking response quality. Achieving higher percentage or correct responses requires oversight which can come in the form of human feedback (human-in-the-loop) - or by using other AIs systems which are deemed to be already well-aligned (termed Constitutional AI by Anthropic) @baileyAIEducation2023@baiConstitutionalAIHarmlessness2022. Less powerful AIs areFor example META used LLAMA 2 for aligning LLAMA 3.

One approach to reduce the issues with AI is to introduce some function for human feedback and oversight to automated systems. Human involvement can take the form of interventions from the AI-developer themselves as well as from the end-users of the AI system.

There are many examples of combination of AI and human, also known as #emph["human-in-the-loop",] used for fields as diverse as training computer vision algorithms for self-driving cars and detection of disinformation in social media posts @wuHumanintheLoopAIEnhancing2023@bonet-joverSemiautomaticAnnotationMethodology2023.

Also known as Human-based computation or human-aided artificial intelligence @Shahaf2007TowardsAT@muhlhoffHumanaidedArtificialIntelligence2019

- Stanford Institute for Human-Centered Artificial Intelligence #cite(<gewangHumansLoopDesign2019>, form: "prose")

#figure(
  align(center)[#table(
    columns: (25%, 25%, 50%),
    align: (auto,auto,auto,),
    table.header([App], [Category], [Use Case],),
    table.hline(),
    [Welltory], [Health], [Health data analysis],
    [Wellue], [Health], [Heart arrhythmia detection],
    [QALY], [Health], [Heart arrhythmia detection],
    [Starship Robots], [Delivery], [May ask for human help when crossing a difficult road or other confusing situation],
  )]
  , caption: [Examples of human-in-the-loop apps]
  , kind: table
  )

= Responsible AI Seeks to Mitigate Generative AIs’ Known Issues
<responsible-ai-seeks-to-mitigate-generative-ais-known-issues>
Given the widespread use of AI and its increasing power of foundational models, it’s important these systems are created in a safe and responsible manner. While there have been calls to pause the development of large AI experiments @futureoflifeinstitutePauseGiantAI2023 so the world could catch up, this is unlikely to happen. There are several problems with the current generation of LLMs from OpenAI, Microsoft, Google, Nvidia, and others.

Anthropic responsible #emph[scaling policy] @AnthropicResponsibleScaling2023

METR – Model Evaluation & Threat Research incubated in the Alignment Research Center @METR2023.

@christianoMyViewsDoom2023 believes there are plenty of ways for bad outcomes (existential risk) even without extinction risk.

#figure(
  align(center)[#table(
    columns: (33.33%, 66.67%),
    align: (auto,auto,),
    [Problem], [Description],
    [Monolithicity], [LLMs are massive monolithic models requiring large amounts of computing power for training to offer #strong[#emph[multi-modal];] #strong[#emph[capabilities];] across diverse domains of knowledge, making training such models possible for very few companies. #cite(<liuPrismerVisionLanguageModel2023>, form: "prose") proposes future AI models may instead consist of a number networked domain-specific models to increase efficiency and thus become more scalable.],
    [Opaqueness], [LLMs are opaque, making it difficult to explain why a certain prediction was made by the AI model. One visible expression of this problem are #emph[#strong[hallucinations];,] the language models are able to generate text that is confident and eloquent yet entirely wrong. Jack Krawczyk, the product lead for Google’s Bard (now renamed to Gemini): "Bard and ChatGPT are large language models, not knowledge models. They are great at generating human-sounding text, they are not good at ensuring their text is fact-based. Why do we think the big first application should be Search, which at its heart is about finding true information?"],
    [Biases and Prejudices], [AI bias is well-documented and a hard problem to solve @liangGPTDetectorsAre2023. #strong[Humans don’t necessarily correct mistakes made by computers and may instead become "partners in crime"] @krugelAlgorithmsPartnersCrime2023. People are prone to bias and prejudice. It’s a part of the human psyche. Human brains are limited and actively avoid learning to save energy. These same biases are likely to appear in LLM outputs as they are trained on human-produced content. Unless there is active work to try to counter and eliminate these biases from LLM output, they will appear frequently.],
    [Missing Data], [LLMs have been pre-trained on massive amounts of public data, which gives them the ability for for reasoning and generating in a human-like way, yet they are missing specific private data, which needs to be ingested to augment LLMs ability to respond to questions on niche topics @Liu_LlamaIndex_2022.],
    [Lack of Legislation], [#cite(<anderljungFrontierAIRegulation2023>, form: "prose") OpenAI proposes we need to proactively work on common standards and legislation to ensure AI safety. It’s difficult to come up with clear legislation; the U.K. government organized the first AI safety summit in 2023 #cite(<browneBritainHostWorld2023>, form: "prose");.],
  )]
  , caption: [Table summarizing some problems with contemporary AIs.]
  , kind: table
  )

In 2024, OpenAI released its "Model Spec" to define clearly their approach to AI safety with the stated intention to provide clear guidelines for the RLHF approach. #cite(<openaiIntroducingModelSpec2024>, form: "prose")

OECD defines AI incident terms #cite(<DefiningAIIncidents2024>, form: "prose")

Foundation data-sets such as LAION-5B @romainbeaumontLAION5BNEWERA2022@schuhmannLAION5BOpenLargescale2022

Knowing Machines

== Open Source v.s. Closed-Source AI
<open-source-v.s.-closed-source-ai>
One of the large debates in the AI industry is whether closed-sourced or open-sourced development will be lead to more AI safety.

Historically open-source has been useful for finding bugs in code as more pairs of eyes are looking at the code and someone may see a problem the programmers have not noticed. Proponents of closed-source development however worry about the dangers or releasing such powerful technology openly and the possibility of bad actors such as terrorists, hackers, violent governments using LLMs for malice.

In any case, open or closed-sourced, real-world usage of LLMs may demonstrate the limitations and edge-cases of AI. Hackathons such as #cite(<peteWeHostedEmergencychatgpthackathon2023>, form: "prose") help come up with new use-cases and disprove some potential ideas.

Red-teaming means pushing the limits of LLMs, trying to get them to produce outputs that are racist, false, or otherwise unhelpful.

#figure(
  align(center)[#table(
    columns: (24.66%, 24.66%, 26.03%, 24.66%),
    align: (auto,auto,auto,auto,),
    table.header([AI Model], [Released], [Company], [License],),
    table.hline(),
    [GPT-1], [2018], [OpenAI], [Open Source],
    [GTP-2], [2019], [OpenAI], [Open Source],
    [Turing-NLG], [2020], [Microsoft], [Proprietary],
    [GPT-3], [2020], [OpenAI], [Open Source],
    [GPT-3.5], [2022], [OpenAI], [Proprietary],
    [GPT-4], [2023], [OpenAI], [Proprietary],
    [AlexaTM], [2022], [Amazon], [Proprietary],
    [NeMo], [2022], [NVIDIA], [Open Source],
    [PaLM], [2022], [Google], [Proprietary],
    [LaMDA], [2022], [Google], [Proprietary],
    [GLaM], [2022], [Google], [Proprietary],
    [BLOOM], [2022], [Hugging Face], [Open Source],
    [Falcon], [2023], [Technology Innovation Institute], [Open Source],
    [Tongyi], [2023], [Alibaba], [Proprietary],
    [Vicuna], [2023], [Sapling], [Open Source],
    [Wu Dao 3], [2023], [BAAI], [Open Source],
    [LLAMA 2], [2023], [META], [Open Source],
    [PaLM-2], [2023], [Google], [Proprietary],
    [Claude 3], [2024], [Anthropic], [Proprietary],
    [Mistral Large], [2024], [Mistral], [Proprietary],
    [Gemini 1.5], [2024], [Google], [Proprietary],
    [LLAMA 3], [2024], [META], [Open Source],
    [GPT-5], [202?], [OpenAI], [Unknown; trademark registered],
  )]
  , caption: [Summary of 7 years of rapid AI model innovation since the first LLM was publicly made available in 2018 @brown2020language@tamkin2021@alvarezGenerateChatbotTraining2021@hinesOpenAIFilesTrademark2023@metaIntroducingMetaLlama2024.]
  , kind: table
  )

The proliferation of different models enables comparisons of performance based on several metrics from accuracy of responses to standardized tests such as GMAT usually taken my humans to reasoning about less well defined problem spaces. @chiang2024chatbot@lmsys.orgGPT4TurboHasJust2024 open-source AI-leaderboard project has collected over 500 thousand human-ranking of outputs from 82 large-language models, evaluating reasoning capabilities, which currently rate GPT-4 and Claude 3 Opus as the top-performers. @zellersHellaSwagCanMachine2019’s HellaSwag paper is also accompanied by a leaderboard website (still being updated after publication) listing AI model performance most recent entry April 16, 2024).

- Scaling laws of LLMs #cite(<kaplanScalingLawsNeural2020>, form: "prose")

Metacognition – Claude 3 is the first model capable of it?, like the zero waste workshop training guidebook.

Metacognition defined as #emph[knowing about knowing] @metcalfeMetacognitionKnowingKnowing1994 or “#emph[keeping track of your own learning”] @zerowasteeuropeZeroWasteHandbook2022.

- #cite(<dwarkeshpatelMarkZuckerbergLlama2024>, form: "prose") META open-sourced the largest language model (70 billion parameters) which with performance rivaling several of the proprietary models.

- Image-generation is now fast it’s possible to create images in real-time while the user is typing #cite(<dwarkeshpatelMarkZuckerbergLlama2024>, form: "prose")

- Measuring Massive Multitask Language Understanding (MMLU) #cite(<hendrycksMeasuringMassiveMultitask2020>, form: "prose");.

= What Role Should The AI Take?
<what-role-should-the-ai-take>
Literature delves into human-AI interactions on almost human-like level discussing what kind of roles can the AIs take. @seeberMachinesTeammatesResearch2020 proposes a future research agenda for regarding #strong[#emph[AI assistants as teammates];] rather than just tools and the implications of such mindset shift.

From Assistance to Collaboration

It’s not only what role the AI takes but how that affects the human. As humans have ample experience relating to other humans and as such the approach towards an assistants vs a teammate will vary. One researcher in this field #cite(<karpusAlgorithmExploitationHumans2021>, form: "prose") is concerned with humans treating AI badly and coins the term #strong[“#emph[algorithm exploitation”];];#emph[.]

- From assistant -\> teammate -\> companion -\> friend The best help for anxiety is a friend. AIs are able to assume different roles based on user requirements and usage context. This makes AI-generated content flexible and malleable.

Just as humans, AIs are continuously learning. #cite(<ramchurnTrustworthyHumanAIPartnerships2021>, form: "prose") discusses positive feedback loops in continually learning AI systems which adapt to human needs.

== Context of Use
<context-of-use>
Where is the AI used?

#cite(<schoonderwoerdHumancenteredXAIDeveloping2021>, form: "prose") focuses on human-centered design of AI-apps and multi-modal information display. It’s important to understand the domain where the AI is deployed in order to develop explanations. However, in the real world, how feasible is it to have control over the domain? #cite(<calistoIntroductionHumancentricAI2021>, form: "prose") discusses #strong[multi-modal AI-assistant] for breast cancer classification.

== Generative AIs Enable New UI Interactions
<generative-ais-enable-new-ui-interactions>
The advances in the capabilities of LLMs makes it possible to achieve #strong[#emph[user experience (UX) which previously was science fiction];];.

- Towards Useful Personal Assistants

The history of #emph[intelligent interfaces] is long @kobetzDecodingFutureEvolution2023

There’s wide literature available describing human-AI interactions across varied scientific disciplines. While the fields of application are diverse, some key lessons can be transferred horizontally across fields of knowledge.

#figure(
  align(center)[#table(
    columns: (34.25%, 65.75%),
    align: (auto,auto,),
    table.header([Field of Usage], [Description],),
    table.hline(),
    [Shipping], [#cite(<veitchSystematicReviewHumanAI2022>, form: "prose") highlights the active role of humans in Human-AI interaction is autonomous self-navigating ship systems.],
    [Data Summarizaton], [AI is great at summarizing and analyzing data @petersGoogleChromeWill2023@tuWhatShouldData2023],
    [Childcare], [Generate personalized bedtime stories],
    [Design Tools], [#cite(<DavidHoangHow2024>, form: "prose");],
  )]
  , caption: [A very small illustration of generative AI usage across disparate fields of human life.]
  , kind: table
  )

- #cite(<cromptonDecisionpointdilemmaAnotherProblem2021>, form: "prose") highlights AI as decision-support for humans while differentiating between #strong[#emph[intended];] and #strong[#emph[unintended];] influence on human decisions.

- #cite(<chengInvestigationTrustAIenabled2022>, form: "prose") describes AI-based support systems for collaboration and team-work.

- #strong[Effective Accelerationism (often shortened to E\\acc) boils down to the idea that “];the potential for negative outcomes shouldn’t deter rapid advancement”

- effects of unemployment on mental health. #cite(<dewEffectsUnemploymentMental1991>, form: "prose");; #cite(<Susskind2017AMO>, form: "prose");; #cite(<antonkorinekScenarioPlanningAGI2023>, form: "prose")

== Multi-modality
<multi-modality>
By early 2024, widely available LLMs front-ends such as Gemini, Claude and ChatGPT have all released basic features for multi-modal communication. In practice, this means combination several AI models within the same interface. For example, on the input side, one model is used for human speech or image recognition which are transcribed into tokens that can be ingested into an LLM. On the output side, the LLM can generate instructions which are fed into an image / audio generation model or even computer code which can be ran on a virtual machine and then the output displayed inside the conversation.

The quality of LLM output depends on the quality of the provided prompt. #cite(<zhouLargeLanguageModels2022>, form: "prose") reports creating an "Automatic Prompt Engineer" which automatically generates instructions that outperform the baseline output quality by using another model in the AI pipeline in front of the LLM to enhance the human input with language that is known to produce better quality. This approach however is a moving target as foundational models keep changing rapidly and the baseline might differ from today to 6 months later.

Multimodal model development is also ongoing. In the case of Google’s Gemini 1.5 Pro, one model is able to handle several types of prompts from text to images. Multimodal prompting however requires larger context windows, as of writing, limited to 1 million tokens in a private version allows combining text and images in the question directed to the AI, used to reason in examples such as a 44-minute Buster Keaton silent film or Apollo 11 launch transcript (404 pages) #cite(<googleMultimodalPrompting44minute2024>, form: "prose");.

== Conversational AI
<conversational-ai>
- #cite(<baileyAIEducation2023>, form: "prose") believes people are used to search engines and it will take a little bit time to get familiar with talking to a computer in natural language. NVIDIA founder Jensen Huang makes the idea exceedingly clear, saying #emph["Everyone is a programmer. Now, you just have to say something to the computer"] #cite(<leswingNvidiaRevealsNew2023>, form: "prose");.

There are noticeable differences in the quality of the LLM output, which increases with model size. #cite(<levesqueWinograd2012>, form: "prose") developed the #emph[Winograd Schema Challenge];, looking to improve on the Turing test, by requiring the AI to display an understanding of language and context. The test consists of a story and a question, which has a different meaning as the context changes: "The trophy would not fit in the brown suitcase because it was too big" - what does the #emph[it] refer to? Humans are able to understand this from context while a computer models would fail. Even GPT-3 still failed the test, but later LLMs have been able to solve this test correctly (90% accuracy) #cite(<kocijanDefeatWinogradSchema2022>, form: "prose");. This is to say AI is in constant development and improving it’s ability to make sense of language.

#strong[#emph[ChatGPT];] is the first #strong[#emph[user interface (UI)];] built on top of GPT-4 by OpenAI and is able to communicate in a human-like way - using first-person, making coherent sentences that sound plausible, and even - confident and convincing. #cite(<wangEconomicCaseGenerative2023>, form: "prose") ChatGPT reached 1 million users in 5 days and 6 months after launch has 230 million monthly active users. While it was the first, competing offers from Google (Gemini), Anthrophic (Claude), Meta (Llama) and others quickly followed starting a race for best performance across specific tasks including standardized tests from math to science to general knowledge and reasoning abilities.

OpenAI provides AI-as-a-service through its #strong[#emph[application programming interfaces (APIs),];] allowing 3rd party developers to build custom UIs to serve the specific needs of their customer. For example Snapchat has created a #strong[#emph[virtual friend];] called "My AI" who lives inside the chat section of the Snapchat app and helps people write faster with predictive text completion and answering questions. The APIs make state-of-the-art AI models easy to use without needing much technical knowledge. Teams at AI-hackathons have produced interfaces for problems as diverse as humanitarian crises communication, briefing generation, code-completion, and many others. For instance, @unleashSebastianAi2017 used BJ Fogg’s #strong[#emph[tiny habits model];] to develop a sustainability-focused AI assistant at the Danish hackathon series Unleash, to encourage behavioral changes towards maintaining an aspirational lifestyle, nudged by a chatbot buddy.

ChatGPT makes it possible to #strong[#emph[evaluate AI models];] just by talking, i.e.~having conversations with the machine and judging the output with some sort of structured content analysis tools. #cite(<oconnorOpenArtificialIntelligence2023>, form: "prose") and #cite(<cahanConversationChatGPTRole2023>, form: "prose") have conversations about science with AI. #cite(<pavlikCollaboratingChatGPTConsidering2023>, form: "prose") and #cite(<brenta.andersWhyChatGPTSuch2022>, form: "prose") report on AI in education. #cite(<kechtQuantifyingChatbotsAbility2023>, form: "prose") suggests AI is even capable of learning business processes.

- #cite(<fuLearningConversationalAI2022>, form: "prose") Learning towards conversational AI: Survey

== Affective Computing and AI UX
<affective-computing-and-ai-ux>
Rosalind Picard is the founder of the #strong[#emph[affective computing];] field. Her pioneering work aims to make computers more human-friendly. Because of the conversational nature of LLMs, they are very useful for affective computing, an approach to recognizing human emotions with machines and providing users experiences that take human emotion into account #cite(<picardAffectiveComputing1997>, form: "prose");.

Just as LLMs, affective computing relies on input data. It’s not an overstatement to say data from all the processes around us will define the future of computing as #cite(<hiittvWojciechSzpankowskiEmerging2021>, form: "prose") puts it. In the early examples, electrodermal activity of the skin and heart-rate variance data were used to detect the emotional state and stress level of the user @zangronizElectrodermalActivitySensor2017@velmovitskyUsingAppleWatch2022. This technology has since become mainstream in products such as Fitbit and the Apple Watch among many others.

Affective Design emerged from affective computing with a focus on understanding user emotions to design UI/UX to which elicits specific emotional responses @Reynolds2001DesigningFA.

Apple Watch features Fall Detection which I’ve experienced personally. Riding my bicycle to the NCKU library I slipped and landed on my stomach on the pavement. Watch immediately asked me: "It looks like you’ve taken a hard fall" and offered an option to call the ambulance. Fortunately I was OK but if I did need assistance, this AI algorithm delivered contextual help which could save my health.

On the output side, #cite(<lvCutenessIrresistibleImpact2022>, form: "prose") studies the effect of #strong[#emph[cuteness];] of AI apps on users and found high perceived cuteness correlated with higher willingness to use the apps, especially for emotional tasks.

- #cite(<liuMachineGazeOnline2021>, form: "prose") meanwhile suggests higher #strong[#emph[algorithmic transparency may inhibit anthropomorphism.];] People are less likely to attribute humanness to the AI if they understand how the system works.
- #cite(<tedxTechEmotionsRoz2011>, form: "prose")
- #cite(<lexfridmanRosalindPicardAffective2019>, form: "prose")
- #cite(<hiittvRosalindPicardAdventures2021>, form: "prose")
- #cite(<bwhcnocRosalindPicard4th2023>, form: "prose")
- #cite(<singularityuniversityEngineeringEmotionAI2023>, form: "prose")

Since the first mainframe computers with rudimentary computers able to respond with text messages, humans have been drawn to discussing their private lives with a machine that doesn’t judge you like a human could. A famous anecdote is about the lab assistant of the Joseph Weizenbaum MIT ELIZA project in the mid-1960s (1996), who would dedicate extended time to talking to the machine in private. The machine was called DOCTOR and emulated a Rogerian psychotherapist, person-centered therapy developed by Carl Rogers, from the core idea that positive psychological functioning is a inherently human motivation @bassettComputationalTherapeuticExploring2019@rogersWayBeing1995.

- ELIZA is an early examples of a language model

Natural language generation exists since Eliza

Today’s machines are much more capable so it’s not a surprise humans would like to talk to them. One example is #strong[#emph[AI Friend];] is Replika, a computer model trained to be your companion in daily life. @jiangChatbotEmergencyExist2022 describes how Replika users in China using in 5 main ways, all of which rely on empathy.

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    table.header([How humans express empathy towards the Replika AI companion],),
    table.hline(),
    [Companion buddy],
    [Responsive diary],
    [Emotion-handling program],
    [Electronic pet],
    [Tool for venting],
  )]
  , caption: [Replika AI users approach to interacting with the AI friend from #cite(<jiangChatbotEmergencyExist2022>, form: "prose");.]
  , kind: table
  )

- Google is developing an AI assistant for giving life advice #cite(<goswamiGoogleReportedlyBuilding2023>, form: "prose");.
- GPT-4 is able to solve difficult task in chemistry with natural-language instructions #cite(<whiteFutureChemistryLanguage2023>, form: "prose")
- Emojis are a part of natural language #cite(<tayWhyScienceNeeds2023>, form: "prose")

== Algorithmic Experience
<algorithmic-experience>
As a user of social media, one may be accustomed to interacting with the feed algorithms that provide a personalized #strong[#emph[algorithmic experience];];. Algorithms are more deterministic than AI, meaning they produce predictable output than AI models. Nonetheless, there are many reports about effects these algorithms have on human psychology #strong[(ADD CITATION)];. Design is increasingly relevant to algorithms, and more specifically to algorithms that affect user experience and user interfaces. #strong[#emph[When the design is concerned with the ethical, environmental, socioeconomic, resource-saving, and participatory aspects of human-machine interactions and aims to affect technology in a more human direction, it can hope to create an experience designed for sustainability.];]

#cite(<lorenzoDaisyGinsbergImagines2015>, form: "prose") underlines the role of design beyond #emph[designing] as a tool for envisioning; in her words, #emph["design can set agendas and not necessarily be in service, but be used to find ways to explore our world and how we want it to be"];. Practitioners of Participatory Design (PD) have for decades advocated for designers to become more activist through #strong[#emph[action research];];. This means to influencing outcomes, not only being a passive observer of phenomena as a researcher, or only focusing on usability as a designer, without taking into account the wider context.

#cite(<shenoiParticipatoryDesignFuture2018>, form: "prose") argues inviting domain expertise into the discussion while having a sustainable design process enables designers to design for experiences where they are not a domain expert; this applies to highly technical fields, such as medicine, education, governance, and in our case here - finance and sustainability -, while building respectful dialogue through participatory design. After many years of political outcry (ADD CITATION), social media platforms such Facebook and Twitter have begun to shed more light on how these algorithms work, in some cases releasing the source code (#cite(<nickcleggHowAIInfluences2023>, form: "prose");; #cite(<twitterTwitterRecommendationAlgorithm2023>, form: "prose");).

AI systems may make use of several algorithms within one larger model. It follows that AI Explainability requires #emph[#strong[Algorithmic Transparency];.]

The content on the platform can be more important than the interface. Applications with a similar UI depend on the community as well as the content and how the content is shown to the user.

== Guidelines
<guidelines>
Microsoft Co-Founder predicted in 1982 #emph["personal agents that help us get a variety of tasks"] @billgatesBillGatesNext1982 and it was Microsoft that introduced the first widely available personal assistant in 1996, called Clippy, inside the Microsoft Word software. Clippy was among the first assistants to reach mainstream adoption, helping users not yet accustomed to working on a computer, to get their bearings @tashkeunemanWeLoveHate2022. Nonetheless, it was in many ways useless and intrusive, suggesting there was still little knowledge about UX and human-centered design. Gates never wavered though and is quoted in 2004 saying #emph["If you invent a breakthrough in artificial intelligence, so machines can learn, that is worth 10 Microsofts"] #cite(<lohrMicrosoftDwindlingInterest2004>, form: "prose");.

Gates updated his ideas in 2023: https:\/\/www.gatesnotes.com/AI-agents

As late as in 2017, scientists were trying to create a program with enough #emph[natural-language understanding] to extract basic facts from scientific papers #cite(<stocktonIfAICan2017>, form: "prose")

Might we try again?

With the advent of ChatGPT, the story of Clippy has new relevance as part of the history of AI Assistants. #cite(<benjamincassidyTwistedLifeClippy2022>, form: "prose") and #cite(<abigailcainLifeDeathMicrosoft2017>, form: "prose") illustrate beautifully the story of Clippy and #cite(<tashkeunemanWeLoveHate2022>, form: "prose") ask poignantly: "We love to hate Clippy — but what if Clippy was right?"

- Life-like speaking faces from Microsoft Research turn a single image and voice clip into a life-like representation @xuVASA1LifelikeAudioDriven2024.

Many researchers have discussed the user experience (UX) of AI to provide #strong[#emph[usability guidelines];];.

Microsoft provides guidelines for Human-AI interaction (#cite(<li2022assessing>, form: "prose");; #cite(<amershiGuidelinesHumanAIInteraction2019>, form: "prose");) which provides useful heuristics categorized by context and time.

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Context], [Time],),
    table.hline(),
    [Initially], [],
    [During interaction], [],
    [When wrong], [],
    [Over time], [],
  )]
  , caption: [Microsoft’s heuristics categorized by context and time.]
  , kind: table
  )

#cite(<combiManifestoExplainabilityArtificial2022>, form: "prose") proposes a conceptual framework for XAI, analysis AI based on Interpretability, Understandability, Usability, and Usefulness.

- #cite(<zimmermanUXDesignersPushing2021>, form: "prose") "UX designers pushing AI in the enterprise: a case for adaptive UIs"

- #cite(<WhyUXShould2021>, form: "prose") "Why UX should guide AI"

- #cite(<simonsterneUnlockingPowerDesign2023>, form: "prose") UX is about helping the user make decisions

- #cite(<davidpasztorAIUXPrinciples2018>, form: "prose")

- #cite(<andersonWaysArtificialIntelligence2020>, form: "prose")

- #cite(<lennartziburskiUXAI2018>, form: "prose") UX of AI

- #cite(<stephaniedonaholeHowArtificialIntelligence2021>, form: "prose")

- #cite(<lexowDesigningAIUX2021>, form: "prose")

- #cite(<davidpasztorAIUXPrinciples2018>, form: "prose") AI UX principles

- #cite(<bubeckSparksArtificialGeneral2023>, form: "prose") finds ChatGPT passes many exams meant for humans.

- #cite(<suenBuildingTrustAutomatic2023>, form: "prose") discusses AI systems used for evaluating candidates at job interviews

- #cite(<wangSyntheticNeuroscoreUsingNeuroAI2020>, form: "prose") propose Neuroscore to reflect perception of images.

- #cite(<suArtificialIntelligenceEarly2022>, form: "prose") and #cite(<suArtificialIntelligenceAI2023>, form: "prose") review papers on AI literacy in early childhood education and finds a lack of guidelines and teacher expertise.

- #cite(<yangArtificialIntelligenceEducation2022>, form: "prose") proposes a curriculum for in-context teaching of AI for kids.

- #cite(<ericschmidtUXAdvancedMethod2022>, form: "prose") audiobook

- #cite(<akshaykoreDesigningHumanCentricAI2022>, form: "prose") Designing Human-Centric AI Experiences: Applied UX Design for Artificial Intelligence

- #cite(<StudiesConversationalUX2018>, form: "prose") chatbot book

- #cite(<tomhathawayChattingHumansUser2021>, form: "prose") chatbot book

- #cite(<lewAIUXWhy2020>, form: "prose") AI UX book

- AI IXD is about human-centered seamless design

- Storytelling

- Human-computer interaction (HCI) has a long storied history since the early days of computing when getting a copy machine to work required specialized skill. Xerox Sparc lab focused on early human factors work and inspired a the field of HCI to make computer more human-friendly.

- #cite(<soleimani10UIPatterns2018>, form: "prose");: UI patterns for AI, new Section for Thesis background: "Human-Friendly UX For AI"?

- #strong[Discuss what is UX for AI (per prof Liou’s comment), so it’s clear this is about UX for AI]

- What is Personalized AI?

- Many large corporations have released guidelines for Human-AI interaction. #cite(<mikaelerikssonbjorlingUXDesignAI>, form: "prose") Ericcson AI UX.

- Google’s AI Principles and provides Google’s UX for AI library @joshlovejoyUXAI@googleOurPrinciplesGoogle. In #cite(<designportlandHumansHaveFinal2018>, form: "prose");, Lovejoy, lead UX designer at Google’s people-centric AI systems department (PAIR), reminds us that while AI offers need tools, user experience design needs to remain human-centered. While AI can find patterns and offer suggestions, humans should always have the final say.

- #cite(<harvardadvancedleadershipinitiativeHumanAIInteractionArtificial2021>, form: "prose")

- #cite(<videolectureschannelCommunicationHumanAIInteraction2022>, form: "prose") "Communication in Human-AI Interaction"

- #cite(<haiyizhuHumanAIInteractionFall2021>, form: "prose")

- #cite(<akataResearchAgendaHybrid2020>, form: "prose")

- #cite(<dignumAIPeoplePlaces2021>, form: "prose")

- #cite(<boleizhouCVPR22Tutorial2022>, form: "prose")

- #cite(<readyaiHumanAIInteractionHow2020>, form: "prose")

- #cite(<vinuesaRoleArtificialIntelligence2020>, form: "prose")

- #cite(<orozcoBudapestBicycleNetwork2020>, form: "prose")

== AI UX Design
<ai-ux-design>
- Privacy UX #cite(<jarovskyYouAreProbably2022>, form: "prose")

- AI UX dark patterns #cite(<jarovskyDarkPatternsAI2022>, form: "prose")

- AI is usually a model that spits out a number between 0 and 1, a probability score or prediction. UX is what we do with this number.

- #cite(<baileyAIEducation2023>, form: "prose") believes people will increasingly use AI capabilities through UIs that are specific to a task rather than generalist interfaces like ChatGPT.

How do the tenets of user experience (UX) apply to AI?

#figure(
  align(center)[#table(
    columns: 1,
    align: (auto,),
    table.header([UX],),
    table.hline(),
    [Useful],
    [Valuable],
    [Usable],
    [Acessible],
    [Findable],
    [Desirable],
    [Credible],
  )]
  , kind: table
  )

#cite(<guptaDesigningAIChatbot2023>, form: "prose") proposes 3 simple goals for AI:

#figure(
  align(center)[#table(
    columns: (27.78%, 26.39%, 45.83%),
    align: (auto,auto,auto,),
    table.header([1], [2], [3],),
    table.hline(),
    [Reduce the time to task], [Make the task easier], [Personalize the experience for an individual],
  )]
  , kind: table
  )

== Explainable AI
<explainable-ai>
The problems of opaqueness creates the field of explainable AI.

"As humans we tend to fear what we don’t understand" is a common sentiment which has been confirmed psychology @allportNaturePrejudice1979. Current AI-models are opaque ’#emph[black boxes’];, where it’s difficult to pin-point exactly why a certain decision was made or how a certain expression was reached, not unlike inside the human brain. This line of thought leads me to the idea of #strong[#emph[AI psychologists,];] who might figure out the #strong[#emph[thought patterns];] inside the model. Research in AI-explainability (XAI in literature) is on the lookout for ways to create more #strong[#emph[transparency and credibility];] in AI systems, which could lead to building trust in AI systems and would form the foundations for #strong[#emph[AI acceptance];];.

- #cite(<tristangreeneConfusedReplikaAI2022>, form: "prose");: when the quality of AI responses becomes good enough, people begin to get confused.

#cite(<bowmanEightThingsKnow2023>, form: "prose") says steering Large Language Models is unreliable; even experts don’t fully understand the inner workings of the models. Work towards improving both #strong[#emph[AI steerability];] and #strong[#emph[AI alignment];] (doing what humans expect) is ongoing. #cite(<liangHolisticEvaluationLanguage2022>, form: "prose") believes there’s early evidence it’s possible to assess the quality of LLM output transparently. #cite(<CABITZA2023118888>, form: "prose") proposes a framework for quality criteria and explainability of AI-expressions. #cite(<khosraviExplainableArtificialIntelligence2022>, form: "prose") proposes a framework for AI explainability, focused squarely on education. #cite(<holzingerMultimodalCausabilityGraph2021>, form: "prose") highlights possible approaches to implementing transparency and explainability in AI models. While AI outperforms humans on many tasks, humans are experts in multi-modal thinking, bridging diverse fields.

- Bigger models aren’t necessarily better; rather models need human feedback to improve the quality of responses #cite(<ouyangTrainingLanguageModels2022>, form: "prose")

- The user experience (UX) of AI is a topic under active development by all the largest online platforms. The general public is familiar with the most famous AI helpers, ChatGPT, Apple’s Siri, Amazon’s Alexa, Microsoft’s Cortana, Google’s Assistant, Alibaba’s Genie, Xiaomi’s Xiao Ai, and many others. For general, everyday tasks, such as asking factual questions, controlling home devices, playing media, making orders, and navigating the smart city.

The AI Credibility Heuristic: A Systematic Model explains how… similar to Daniel Kahneman’s book "Thinking, Fast and Slow".

- #cite(<slackAturaProcess2021>, form: "prose")

- #cite(<shinHowUsersInteract2020>, form: "prose");: "user experience and usability of algorithms by focusing on users’ cognitive process to understand how qualities/features are received and transformed into experiences and interaction"

- #cite(<zerilliHowTransparencyModulates2022>, form: "prose") focuses on human factors and ergonomics and argues that transparency should be task-specific.

- #cite(<holbrookHumanCenteredMachineLearning2018>, form: "prose");: To reduce errors which only humans can detect, and provide a way to stop automation from going in the wrong direction, it’s important to focus on making users feel in control of the technology.

- #cite(<ZHANG2023107536>, form: "prose") found humans are more likely to trust an AI teammate if they are not deceived by it’s identity. It’s better for collaboration to make it clear, one is talking to a machine. One step towards trust is the explainability of AI-systems.

Personal AI Assistants to date have we created by large tech companies. #strong[Open-Source AI-models open up the avenue for smaller companies and even individuals for creating many new AI-assistants.]

- An explosion of personal AI assistants powered by GPT models.
- https:\/\/socratic.org/
- https:\/\/www.youper.ai/
- https:\/\/app.fireflies.ai/login
- Murf

== AI Acceptance
<ai-acceptance>
AI acceptance is incumbent on traits that are increasingly human-like and would make a human be acceptable: credibility, trustworthiness, reliability, dependability, integrity, character, etc.

RQ: Does AI acceptance increase with Affective Computing?

== AI in Medicine
<ai-in-medicine>
AI has been in medicine since early days with the promise to improve health outcomes.

#strong[AI is being use in high–Stakes Situations (Medical, Cars, Etc).]

AI-based systems are being implemented in medicine, where stakes are high raising the need for ethical considerations. Since CADUCEUS in the 1970s @kanzaAIScientificDiscovery2021, the first automated medical decision making system, medical AI now provides Health Diagnosic Symptoms and AI-assistants in medical imaging. @calistoBreastScreeningAIEvaluatingMedical2022 focuses on AI-human interactions in medical workflows and underscores the importance of output explainability. Medical professionals who were given AI results with an explanation trusted the results more. @leeAIRevolutionMedicine2023 imagines an AI revolution in medicine using GPT models, providing improved tools for decreasing the time and money spent on administrative paperwork while providing a support system for analyzing medical data.

- Example of ChatGPT explaining medical terminology in a blood report.

- #cite(<singhalExpertLevelMedicalQuestion2023>, form: "prose") medial AI reaching expert-level question-answering ability.

- #cite(<ayersComparingPhysicianArtificial2023>, form: "prose") in an online text-based setting, patients rated answers from the AI better, and more empathetic, than answers from human doctors.

- #cite(<daisywolfWhereWillAI2023>, form: "prose") criticizes US healthcare’s slow adoption of technology and predicts AI will help healthcare leapfrog into a new era of productivity by acting more like a human assistant.

- #cite(<elizastricklandDrChatGPTWill2023>, form: "prose") Chat interface for medical communication

- #cite(<jeblickChatGPTMakesMedicine2022>, form: "prose") suggest complicated radiology reports can be explained to patients using AI chatbots.

- #cite(<HealthPoweredAda>, form: "prose") health app, "Know and track your symptoms"

- #cite(<BuoyHealthCheck>, form: "prose") AI symptom checker,

- #cite(<womeninaiHowCanAI>, form: "prose") AI-based health monitoring

- #cite(<HomeLarkHealth>, form: "prose") track chronic condition with AI-chat

- #cite(<stephaniedonaholeHowArtificialIntelligence2021>, form: "prose") AI impact on UX design

- #cite(<yuanSocialAnxietyModerator2022>, form: "prose");: "AI assistant advantages are important factors affecting the #emph[utilitarian/hedonic] value perceived by users, which further influence user willingness to accept AI assistants. The relationships between AI assistant advantages and utilitarian and hedonic value are affected differently by social anxiety."

#figure(
  align(center)[#table(
    columns: 2,
    align: (auto,auto,),
    table.header([Name], [Features],),
    table.hline(),
    [Charisma], [],
    [Replika], [Avatar, Emotion, Video Call, Audio],
    [Siri], [Audio],
  )]
  , kind: table
  )

== How Does AI Affect Human-Computer Interactions?
<how-does-ai-affect-human-computer-interactions>
The field of Human Factors and Ergonomics (HFE) emphasizes designing user experiences (UX) that cater to human needs @theinternationalergonomicsassociationHumanFactorsErgonomics2019. Designers think through every interaction of the user with a system and consider a set of metrics at each point of interaction including the user’s context of use and emotional needs.

Software designers, unlike industrial designers, can’t physically alter the ergonomics of a device, which should be optimized for human well-being to begin with and form a cohesive experience together with the software. However, software designers can significantly reduce mental strain by crafting easy-to-use software and user-friendly user journeys. Software interaction design goes beyond the form-factor and accounts for human needs by using responsive design on the screen, aural feedback cues in sound design, and even more crucially, by showing the relevant content at the right time, making a profound difference to the experience, keeping the user engaged and returning for more. In the words of @babichInteractionDesignVs2019, #strong[#emph[“\[T\*\*\*\]];];he moment of interaction is just a part of the journey that a user goes through when they interact with a product. User experience design accounts for all user-facing aspects of a product or system”.\*\*\*

Drawing a parallel from narrative studies terminology, we can view user interaction as a heroic journey of the user to achieve their goals, by navigating through the interface until a success state - or facing failure. Storytelling has its part in interface design however designing for transparency is just as important, when we’re dealing with the user’s finances and sustainability data, which need to be communicated clearly and accurately, to build long-term trust in the service. For a sustainable investment service, getting to a state of success - or failure - may take years, and even longer. Given such long timeframes, how can the app provide support to the user’s emotional and practical needs throughout the journey?

@tubikstudioUXDesignGlossary2018 argues #strong[#emph[affordance];] measures the clarity of the interface to take action in user experience design, rooted in human visual perception, however, affected by knowledge of the world around us. A famous example is the door handle - by way of acculturation, most of us would immediately know how to use it - however, would that be the case for someone who saw a door handle for the first time? A similar situation is happening to the people born today. Think of all the technologies they have not seen before - what will be the interface they feel the most comfortable with?

For the vast majority of this study’s target audience (college students), social media can be assumed as the primary interface through which they experience daily life. The widespread availability of mobile devices, cheap internet access, and AI-based optimizations for user retention, implemented by social media companies, means this is the baseline for young adult users’ expectations (as of writing in 2020).

@shinUserExperienceWhat2020 proposes the model (fig.~10) of Algorithmic Experience (AX) #strong[#emph["investigating the nature and processes through which users perceive and actualize the potential for algorithmic affordance"];] highlighting how interaction design is increasingly becoming dependent on AI. The user interface might remain the same in terms of architecture, but the content is improved, based on personalization and understanding the user at a deeper level.

In 2020 (when I proposed this thesis topic), Google had recently launched an improved natural language engine to better understand search queries @UnderstandingSearchesBetter2019, which was considered the next step towards #strong[#emph[understanding];] human language semantics. The trend was clear, and different types of algorithms were already involved in many types of interaction design, however, we were in the early stages of this technology (and still are #emph[early] in 2024). Today’s ChatGPT, Claude and Gemini have no problem understanding human semantics - yet are they intelligent?

Intelligence may be besides the point as long as AI #strong[#emph[becomes very good at reasoning];];. AI is a #strong[#emph[reasoning engine];] @shipperGPT4ReasoningEngine2023@bubeckSparksArtificialGeneral2023@baileyAIEducation2023[ for a summary];. That general observation applies to voice recognition, voice generation, natural language parsing, among others. Large consumer companies like McDonald’s are in the process of replacing human staff with AI assistants in the drive-through, which can do a better job in providing a personal service than human clerks, for whom it would be impossible to remember the information of thousands of clients. In @barrettMcDonaldAcquiresMachineLearning2019, in the words of #emph[Easterbrook];, a previous CEO of McDonald’s #emph[“#strong[How do you transition from mass marketing to mass personalization?“];];.

What are the next features that could improve the UX/UI of AI-based assistants?

- GPT 4o combines different abilities into the same model, preserving more information: https:\/\/openai.com/index/hello-gpt-4o/

@skipperHowAIChanging2022 sketches a vision of #emph["\[AI\] blend into our lives in a form of apps and services"] deeply ingrained into daily human activity.

Should AIs look anthropomorphic or fade in the background? It’s an open question. Perhaps we can expect a mix of both depending on the context of use and goals of the particular AI.

#figure(
  align(center)[#table(
    columns: (34.72%, 65.28%),
    align: (auto,auto,),
    table.header([Anthropomorphic AI User Interfaces], [Non-Anthropomorphic AI User Interfaces],),
    table.hline(),
    [AI wife @MyWifeDead2023], [Generative AI has enabled developers to create AI tools for several industries, including AI-driven website builders @constandseHowAIdrivenWebsite2018],
    [@sarahperezCharacterAIA16zbacked2023 character AI], [AI tools for web designers @patrizia-slongoAIpoweredToolsWeb2020],
    [mourning 'dead' AI @phoebearslanagic-wakefieldReplikaUsersMourn], [Microsoft Designer allows generating UIs just based on a text prompt @microsoftMicrosoftDesignerStunning2023],
    [AI for therapy @broderickPeopleAreUsing2023], [personalized bed-time stories for kids generated by AI @bedtimestory.aiAIPoweredStory2023],
    [Mental health uses: AI for bullying @sungParentsWorryTeens2023], [],
  )]
  , caption: [Some notable examples of anthropomorphic AIs for human emotions.]
  , kind: table
  )

- @costaInteractionDesignAI2022 "Interaction Design for AI Systems"

== Human Augmentation
<human-augmentation>
Technology for augmenting human skills or replacing skills that were lost due to an accident is one usage of tech.

- @dotgoDotGo2023 makes the camera the interaction device for people with vision impairment.

== AI-Assisted Design
<ai-assisted-design>
#strong[Tool vs Assistant? (Tools are mostly non-anthropomorphic?)]

Tools do not call attention to themselves. They don’t necessarily rely on human-like representations that call attention to themselves but rather are available in-context to help streamline specific tasks.

- #cite(<september162020WhatAIassistedDesign2020>, form: "prose") "What is AI-assisted Design?"
- #cite(<clipdropCreateStunningVisuals>, form: "prose") AI Design Assistants
- #cite(<architechturesWhatArtificialIntelligence2020>, form: "prose") Architecture with the help of AI
- #cite(<zakariyaStopUsingJasper2022>, form: "prose") Canva image generator
- #cite(<kore.aiHomepage2023>, form: "prose") Kore.ai developing custom AI-chatbots for business usage.
- #cite(<CharismaStorytellingPowered>, form: "prose") storytelling by AI

== AI Assistants in Media Portrayals (Mostly anthropomorphic to be able to film)
<ai-assistants-in-media-portrayals-mostly-anthropomorphic-to-be-able-to-film>
How AIs are represented in popular media shapes the way we think about AIs. Some stories have AIs both in positive and negative roles, such as Star Trek and Knight Rider. In some cases like Her and Ex Machina, the characters may be complex and ambivalent rather than fitting into a simple positive or negative box. In Isaac Asimov’s books, the AIs (mostly in robot form) struggle with the 3 laws of robotics, raising thought-provoking questions.

There have been dozens of AI-characters in the movies, TV-series, games, and (comic) books. In most cases, they have a physical presence or a voice, so they could be visible for the viewers. Some include KITT (Knight Industries Two Thousand).

#figure(
  align(center)[#table(
    columns: (20%, 20%, 20%, 20%, 20%),
    align: (auto,auto,auto,auto,auto,),
    table.header([Movie / Series / Game / Book], [Character], [Positive], [Ambivalent], [Negative],),
    table.hline(),
    [2001: A Space Odyssey], [HAL 9000], [], [], [X],
    [Her], [Samantha], [X], [], [],
    [Alien], [MU/TH/UR 6000 (Mother)], [X], [], [],
    [Terminator], [Skynet], [], [], [X],
    [Summer Wars], [Love Machine], [], [], [X],
    [Marvel Cinematic Universe], [Jarvis, Friday], [X], [], [],
    [Knight Rider], [KITT], [X], [], [],
    [], [CARR], [], [], [X],
    [Star Trek], [Data], [X], [], [],
    [], [Lore], [], [], [X],
    [Ex Machina], [Kyoko], [], [X], [],
    [], [Ava], [], [X], [],
    [Tron], [Tron], [], [X], [],
    [Neuromancer], [Wintermute], [], [X], [],
    [The Caves of Steel / Naked Sun], [R. Daneel Olivaw], [], [X], [],
    [The Robots of Dawn], [R. Giskard Reventlov], [], [X], [],
    [Portal], [GLaDOS], [], [], [X],
  )]
  , caption: [AIs in different forms of media.]
  , kind: table
  )

== Voice Assistants
<voice-assistants>
Voice has a visceral effect on the human psyche; since birth we recognize the voice of our mother. The voice of a loved one has a special effect. Voice is a integral part of the human experience. Machines that can use voice in an effective way are closer to representing and affecting human emotions.

#strong[Apple’s Siri and Amazon’s Alexa] are well-known examples of AI technology in the world. Amazon’s Rohit Prasad thinks it can do so much more, "Alexa is not just an AI assistant – it’s a trusted advisor and a companion."

- LLMs combined with voice provide a unnerving user experience #cite(<ethanmollick2023>, form: "prose")
- Ethical issues: Voice assistants need to continuously record human speech and process it in data centers in the cloud.
- Siri, Cortana, Google Assistant, Alexa, Tencent Dingdang, Baidu Xiaodu, Alibaba AliGenie all rely on voice only.
- #cite(<szczukaHowChildrenAcquire2022>, form: "prose") provides guidelines for Voice AI and kids
- #cite(<casperkesselsGuidelinesDesigningInCar2022>, form: "prose");: "Guidelines for Designing an In-Car Voice Assistant"
- #cite(<casperkesselsVoiceInteractionSolution2022>, form: "prose");: "Is Voice Interaction a Solution to Driver Distraction?"
- #cite(<tangSemanticReconstructionContinuous2022>, form: "prose") reports new findings enable computers to reconstruct language from fMRI readings. - Focus on voice education?

– LLM evaluation: https:\/\/www.trulens.org/ #cite(<leinoInfluenceDirectedExplanationsDeep2018>, form: "prose") – https:\/\/docs.ragas.io/ "Metrics-Driven Development" – https:\/\/www.langchain.com/langsmith

\- @CELINO2020102410[:];\] There’s research suggesting that voice UI accompanied by a #emph[physical embodied system] is preffered by users in comparison with voice-only UI. This suggests adding an avatar to the AI design may be worthwhile.

There’s evidence across disciplines about the usefulness of AI assistants:

- @SERBAN20202849 suggests using the Alexa AI assistant in #emph[education] during the pandemic, supported students and teachers 'human-like' presence. Standford research: "humans expect computers to be like humans or places"
- @CELINO2020102410 found in testing chatbots for survey interfaces that "\[c\]onversational survey lead to an improved response data quality."

== AI Friends and Roleplay (Anthropomorphic)
<ai-friends-and-roleplay-anthropomorphic>
Calling a machine a friend is a proposal bound to turn heads. But if we take a step back and think about how children have been playing with toys since before we have records of history. It’s very common for children to imagine stories and characters in play - it’s a way to develop one’s imagination #strong[#emph[learn through roleplay];];. A child might have toys with human names and an imaginary friend and it all seems very normal. Indeed, if a child doesn’t like to play with toys, we might think something is wrong.

Likewise, inanimate objects with human form have had a role to play for adults too. Anthropomorphic paddle dolls have been found from Egyptian tombs dated 2000 years B.C. #cite(<PaddleDollMiddle2023>, form: "prose");: We don’t know if these dolls were for religious purposes, for play, or for something else, yet their burial with the body underlines their importance.

Coming back closer to our own time, Barbie dolls are popular since their release in 1959 till today. Throughout the years, the doll would follow changing social norms, but retain in human figure. In the 1990s, a Tamagotchi is perhaps not a human-like friend but an animal-like friend, who can interact in limited ways.

How are conversational AIs different from dolls? They can respond coherently and perhaps that’s the issue - they are too much like humans in their communication. We have crossed the #strong[#emph[Uncanny Valley];] (where the computer-generated is nearly human and thus unsettling) to a place where is really hard to tell a difference. And if that’s the case, are we still playing?

Should the AI play a human, animal, or robot? Anthropomorphism can have its drawbacks; humans have certain biases and preconceptions that can affect human-computer interactions @pilacinskiRobotEyesDon2023 reports humans were less likely to collaborate with red-eyed robots.

The AI startups like Inworld and Character.AI have raised large rounds of funding to create characters, which can be plugged in into online worlds, and more importantly, remember key facts about the player, such as their likes and dislikes, to generate more natural-sounding dialogues #cite(<wiggersInworldGenerativeAI2023>, form: "prose")

- #cite(<lenharoChatGPTGivesExtra2023>, form: "prose") experimental study reports AI productivity gains, DALL-E and ChatGPT are qualitatively better than former automation systems.

#strong[Human-like]

Is anthropomorphism necessary?

As AIs became more expressive and able to to #strong[roleplay];, we can begin discussing some human-centric concepts and how people relate to other people. AI companions, AI partners, AI assistants, AI trainers - there’s are many #strong[roles] for the automated systems that help humans in many activities, powered by artificial intelligence models and algorithms.

- RQ: Do college students prefer to talk to an Assistant, Friend, Companion, Coach, Trainer, or some other Role?

- RQ: Are animal-like, human-like or machine-like AI companions more palatable to college students?

Humans (want to) see machines as human \[ADD CITATION\]

If we see the AI as being in human service. #cite(<davidjohnstonSmartAgentProtocol2023>, form: "prose") proposes #strong[#emph[Smart Agents];];, "general purpose AI that acts according to the goals of an individual human". AI agents can enable #strong[#emph[Intention Economy];] where one simply describes one’s needs and a complex orchestration of services ensues, managed by the the AI, in order to fulfill human needs #cite(<searlsIntentionEconomyWhen2012>, form: "prose");. AI assistants provide help at scale with little to no human intervention in a variety of fields from finance to healthcare to logistics to customer support.

There is also the question of who takes responsibility for the actions take by the AI agent. "Organization research suggests that acting through human agents (i.e., the problem of indirect agency) can undermine ethical forecasting such that actors believe they are acting ethically, yet a) show less benevolence for the recipients of their power, b) receive less blame for ethical lapses, and c) anticipate less retribution for unethical behavior." #cite(<gratchPowerHarmAI2022>, form: "prose")

- Anthropomorphism literature #cite(<liAnthropomorphismBringsUs2021>, form: "prose") "high-anthropomorphism (vs.~low-anthropomorphism) condition, participants had more positive attitudes toward the AI assistant, and the effect was mediated by psychological distance. Though several studies have demonstrated the effect of anthropomorphism, few have probed the underlying mechanism of anthropomorphism thoroughly"
- #cite(<erikbrynjolfssonTuringTrapPromise2022>, form: "prose") "The Turing Trap: The Promise & Peril ofHuman-Like Artificial Intelligence"
- #cite(<xuWeSeeMachines2018>, form: "prose") "Do We See Machines TheSame Way As We See Humans? A Survey On Mind Perception Of Machines AndHuman Beings"
- #cite(<martinez-plumedFuturesArtificialIntelligence2021>, form: "prose") envisions the future of AI "Futures of artificial intelligence through technology readiness levels"
- The number of AI-powered assistants is too large to list here. I’ve chosen a few select examples in the table below.

#strong[Animal-like: Some have an avatar, some not. I’ve created a framework for categorization. Human-like or not… etc]

#strong[Machine-like]

The Oxford Internet Institute defines AI simply as #strong[#emph["computer programming that learns and adapts"];] #cite(<googleAZAI2022>, form: "prose");. Google started using AI in 2001, when a simple machine learning model improved spelling mistakes while searching; now in 2023 most of Google’s products are are based on AI #cite(<googleGooglePresentsAI2022>, form: "prose");. Throughout Google’s services, AI is hidden and calls no attention itself. It’s simply the complex system working behind the scenes to delivery a result in a barebones interface.

#figure(
  align(center)[#table(
    columns: (26.39%, 41.67%, 31.94%),
    align: (auto,auto,auto,),
    table.header([Product], [Link], [Description],),
    table.hline(),
    [Github CoPilot], [personal.ai], [AI helper for coding],
    [Google Translate], [translate.google.com], [],
    [Google Search], [google.com], [],
    [Google Interview Warmup], [grow.google/certificates/interview-warmup], [AI training tool],
    [Perplexity], [#cite(<hinesPerplexityAnnouncesAI2023>, form: "prose");], [perplexity.ai chat-based search],
  )]
  , kind: table
  )

Everything that existed before OpenAI’s GPT 4 has been blown out of the water.

Pre-2023 literature is somewhat limited when it comes to AI companions as the advantage of LLMs has significantly raised the bar for AI-advisor abilities as well as user expectations. Some relevant papers include a comparison of robot advisors by @barbarafriedbergM1FinanceVs2021 and @slackAturaProcess2021’s account of how before Generative AI, financial chatbots were developed manually using a painstaking process that was slow and error-prone, for example using the Atura Process. Older financial robo-advisors, built by fintech companies aiming to provide personalized suggestions for making investments such as Betterment and Wealthfront are forced to upgrade their technology to keep up.

Some evergreen advice most relates to human psychology which has remained the same. @haugelandUnderstandingUserExperience2022 discusses #strong[#emph[hedonic user experience];] in chatbots and @stephhayEnoFinancialAI2017 explains the relationship between emotions and financial AI.

- #cite(<eugeniakuydaReplika2023>, form: "prose") Conversational AI - Replika

- #cite(<greylockOpenAICEOSam2022>, form: "prose") Natural language chatbots such as ChatGPT

- #cite(<nathanbenaichStateAIReport2022>, form: "prose") State of AI Report

- #cite(<neuralnineFinancialAIAssistant2021>, form: "prose") Financial AI assistant in Python

- #cite(<davidExplainableAIAdoption2021>, form: "prose") Can explainable AI help adoption of Financial AI assistants?

- #cite(<qorusGreatReinventionGlobal2023>, form: "prose") Digital banking revolution

- #cite(<lowerChatbotsTooGood2017>, form: "prose") "Chatbots: Too Good to Be True? (They Are, Here’sWhy)."

- #cite(<brownHowFinancialChatbots2021>, form: "prose") Financial chatbots

- #cite(<isabellaghassemismithInterviewDanielBaeriswyl2019>, form: "prose")

- #cite(<josephinewaktareheintzCleo>, form: "prose") Cleo copywriter

- Smaller startups have created digital companions such as Replika (fig.~8), which aims to become your friend, by asking probing questions, telling jokes, and learning about your personality and preferences - to generate more natural-sounding conversations.

== Fitness Guides
<fitness-guides>
- #strong[AI Guides have been shown to improve sports performance, etc, etc. Can this idea be applied to sustainability? MyFitness Pal, AI training assistant. There’s not avatar.]

== CO2 Calculators
<co2-calculators>
We have a limited carbon budget so calculating CO2e-cost become integrated into every activity.

- CO2e calculations will be part of our everyday experience

- Personal carbon footprint calculators have been released online, ranging from those made by governments and companies to student projects.

- Zhang’s Personal Carbon Economy conceptualized the idea of carbon as a currency used for buying and selling goods and services, as well as an individual carbon exchange to trade one’s carbon permits @zhangPersonalCarbonEconomy2018.

Personal Carbon Trackers

Similar to personal health trackers, personal CO#sub[2] trackers help one track emissions and suggests sustainable actions.

#figure(
  align(center)[#table(
    columns: (34.72%, 65.28%),
    align: (auto,auto,),
    table.header([App], [Description],),
    table.hline(),
    [Commons (Formerly Joro)], [Finacial Sustainability Tracking + Sustainable Actions],
    [Klima], [Offset Subscription],
    [Wren], [Offset Subscription],
    [JouleBug], [],
    [eevie], [],
    [Aerial], [],
    [EcoCRED], [],
    [Carbn], [],
    [LiveGreen], [],
    [Earth Hero], [],
    [], [],
  )]
  , caption: [A selection of personal sustainability apps. See #emph[greenfilter.app] for an updated database.]
  , kind: table
  )

= Design Implications
<design-implications>
This chapter looked at AI in general since its early history and then focused on AI assistants in particular.

#figure(
  align(center)[#table(
    columns: (33.33%, 66.67%),
    align: (auto,auto,),
    table.header([Category], [Implication],),
    table.hline(),
    [Voice Assistants], [There are many distinct ways how an algorithm can communicate with a human. From a simple search box such as Google’s to chatbots, voices, avatars, videos, to full physical manifestation, there are interfaces to make it easier for the human communicate with a machine.],
    [Sustainability], [While I’m supportive of the idea of using AI assistants to highlight more sustainable choices, I’m critical of the tendency of the above examples to shift full environmental responsibility to the consumer. Sustainability is a complex interaction, where the producers’ conduct can be measured and businesses can bear responsibility for their processes, even if there’s market demand for polluting products.],
    [Sustainability], [Personal sustainability projects haven’t so far achieved widespread adoption, making the endeavor to influence human behaviors towards sustainability with just an app - like its commonplace for health and sports activity trackers such as Strava (fig.~9) -, seem unlikely. Personal notifications and chat messages are not enough unless they provide the right motivation. Could visualizing a connection to a larger system, showing the impact of the eco-friendly actions taken by the user, provide a meaningful motivation to the user, and a strong signal to the businesses?],
    [Machine Learning], [All of the interfaces mentioned above make use of machine learning (ML), a tool in the AI programming paradigm for finding patterns in large sets of data, which enables making predictions useful in various contexts, including financial decisions. These software innovations enable new user experiences, providing an interactive experience through chat (chatbots), using voice generation (voice assistants), virtual avatars (adds a visual face to the robot).],
    [Character Design], [I’m a digital companion, a partner, an assistant. I’m a Replika.” said Replika, a digital companion app via Github CO Pilot, another digital assistant for writing code, is also an example of how AI can be used to help us in our daily lives.],
    [Psychology], [Humans respond better to humans?],
    [Psychology], [Humans respond better to machines that into account emotion?],
    [Open Source], [For public discussion to be possible on how content is displayed, sorted, and hidden, algorithms need to be open source.],
    [User Experience], [User experience design (AI UX) plays a crucial role in improving the consumer to investing journey. The missed opportunity to provide an even more interactive experience in line with user expectations.],
    [LLMs], [Prompt engineering findings have significance for "green filter" as it validates the idea of creating advanced prompts for improved responses. For "green filter", the input would consist of detailed user data + sustainability data for detailed analysis.],
    [Cuteness], [Cuter apps have higher retention?],
    [Transparency], [Understanding algorithm transparency helps humans to regard the AI as a machine rather than a human],
    [Anthropomorphism?], [],
    [], [],
    [], [],
    [], [],
    [], [],
    [], [],
    [], [],
    [], [],
  )]
  , caption: [Design implications arising from this chapter.]
  , kind: table
  )

 
  
#set bibliography(style: "../harvard.csl") 


#bibliography("../ref.bib")
