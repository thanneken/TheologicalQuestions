*Theological Questions* is an Open Educational Resource (free textbook) that originates from St. Mary’s University in San Antonio. 
There it is used in the first of two required core theology courses. 
It is designed to give a broad historical overview of theological questions from the perspective of the Catholic tradition. 
It seeks to represent fairly a variety of questions and answers within and beyond the Catholic tradition. 
It is free to use and modify (see below). 

# How do I read it?
*Theological Questions* is available in formats for 
[web](https://thanneken.github.io/TheologicalQuestions/derivatives/TheologicalQuestions.html), 
[Kindle ePub](https://thanneken.github.io/TheologicalQuestions/derivatives/TheologicalQuestions.epub), 
and [PDF virtual paper](https://thanneken.github.io/TheologicalQuestions/derivatives/TheologicalQuestions.pdf). 
Just remember that citing by page will not be meaningful to readers using other formats. 
The section numbers are standard across formats. 
Enjoy!

There is only one version for now. When there are alternative versions they will be selectable. 

# What can I do with it besides read it?
The Creative Commons BY-NC means you can do anything with it as long as you credit the original contributors appropriately, and do not use it commercially (for profit or potential profit). 
Please consider contributing back your improvements (next). 
It is not considered a commercial use to apply for a grant to build on the project as long as the end result remains free. 

# How do I contribute back my improvements? 
Improvements are welcome in all areas, including corrections/clarifications, additional sections and subsections, supplementary readings and exercises, and improvements to appearance and accessibility. 

## If interested in theology and teaching, not TEI or GitHub
If you have no technical interests, the simplest method is to be in email contact with the author, Todd Hanneken. 
Please remember that page numbers are not helpful. 
A distinctive phrase is the most helpful way of indicating a location. 
Contributions can be treated in at least two ways. 
A “friendly amendment” can be incorporated into the master document and credit will be given. 
The other option is to create an alternative version (called a “fork”) that  pursues a diverging set of interests. 
There is no charge for any of this. 

## If interested in understanding and using the underlying technologies
If you or your team do have technical interests it is possible to do everything on your own without involving the original author. 
GitHub allows anyone to develop a new fork (which may or may not be pulled back into the master). 
GitHub also allows you to identify “issues” for which more discussion is needed beyond simply suggesting a correction. 
The format and tools provided by the Text Encoding Initiative (TEI) Consortium are standard and relatively simple for some modifications (more so the text, less so the formatting). 
With TEI it is important to note the distinction between what a part of a text is and how it should look. 
For example, in TEI we distinguish between words being emphasized, words in a foreign language, and the title of a book, even though those all end up looking the same, that is italicized. 
All matters of content and identification of the nature of the text can be found in `source/TheologicalQuestions.xml`. 
When making modifications, please make appropriate modifications to the header and label additions and corrections with the "resp" (responsibility) attribute to give yourself credit. 

Most matters of formatting are governed by the stylesheets. 
The directory `stylesheets/profiles/theologicalquestions/` contains special formatting that builds on the default stylesheets offered by the TEI Consortium. 
As with the text itself, friendly ammendments and alternative versions of the stylesheet profile are welcome. 

The included scripts will run on Linux, MacOS, and WSL (Windows Subsystem for Linux). 
The scripts require simple modification of the BASEPATH variable and the tools provided by the 
[TEI Consortium](https://github.com/TEIC/Stylesheets).
