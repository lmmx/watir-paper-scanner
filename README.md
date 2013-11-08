watir-paper-scanner
===================

<sup>Original goal: "<i>Browser automation using Watir (Web Application Testing in Ruby) to pull metadata from pages where unavailable through XML.</i>"</sup>

The <i>corresponding author</i> (CA) of a paper isn't available through Pubmed's search results, so I'm writing a few Ruby scripts in an attempt to obtain it on demand.

For anyone interested in how this works, the CA is indicated on an article's abstract page by:
<ul>
<li> [<i>most simply</i>] an <code>&lt;xref&gt;</code> tag enclosing an asterisk (*)
<li> an <code>&lt;xref&gt;</code> tag with <code>ref-type="corresp"</code>
<li> a <code>&lt;contrib&gt;</code> tag with <code>corresp="yes"</code>
<li> etc.
</ul>

Due to this inconsistency, even in Pubmed Central's supposedly consistently formatted eUtils XML files, this isn't the simplest situation to code for (although at least in this the CA can always be determined). The Nokogiri Ruby library with its support of xpaths allows dynamic selection of tags and their attributes, navigating in and out of the XML DOM tree, with the only requirement being a URL to take this information from.

A sample of over 500 results of a Pubmed query (.csv output stored in an online Google Spreadsheet with public read/write permissions), a sample of over 500 papers is in use to test the code. All being well, it would not be too difficult to render the spreadsheet's few formulae (mostly RegEx) in code and integrate this program directly into Pubmed's search API for a functioning web app or something similar! Heath Anderson has written a Ruby version of the Pubmed search API <a href="https://gist.github.com/handerson/2703006">here</a>.

For further details on why this is needed or how it ought to be working, please see the questions I've posted regarding the issue at <a href="http://www.biostars.org/p/82578/">Biostars</a>, <a href="http://researchgate.net/post/Is_it_possible_to_obtain_corresponding_author_from_DOI_metadata">ResearchGate</a> and most recently the <i><a href="https://groups.google.com/forum/#!topic/scraperwiki/uVfQ866Xr5U">Scraperwiki</i> Google group</a>.

Solution
===================

The approach taken is :
<ol>
<li>For the minority of papers (~10%) hosted in Pubmed Central (PMC), simply parse the eUtils XML file (included in Pubmed search output) with Nokogiri for tags as described above and match the name found to surnames already obtained in the search results to confirm CA.
<li>The URL for many of the remaining papers can be accesed from an available Digital Object Identifier (DOI) key, as simply http://dx.doi.org/DOI-goes-here, and from there parsed in text as for XML (but probably with less ease). A variety of methods can be used for this, with brute regular expressions likely being the last resort over names found in HTML tags and found to match those of the record's search result.
<li>The URL for those papers having neither a DOI key, nor a copy in PMC may then require:
<ul>
<li>finding a URL to the article's page on the journal website within the HTML of the Pubmed abstract page,
<li>finding a DOI hidden in the wrong place (searching the whole abstract page's HTML indiscriminately)
<li>headless browser automation with Watir (though this is slow and a last resort - despite the repo name!)
</ul>
</ol>

The end product also ought to be aware that there are sometimes "equally corresponding" authors and handle multiple corresponding authors as is often stated.

<h2>Parlez-vous <i>Ruby</i>?</h2>
I'm a life sciences undergraduate with <i>no formal training</i> in code (hopefully it doesn't show) beyond what I've picked up through practice, and am extremely grateful for the patience and assistance of more experienced Ruby programmers.

Once fully functional, I'd love to make this freely available as an online tool (as to my knowledge it's not a great cost to deploy these things) for other academics as well as leaving the code here, and would be happy for it to be put to use in your project - feel free to contact me through naivelocus@gmail.com with any ideas.

Any and all help given on the code in the meantime is greatly appreciated :~)

<b>Louis Maddox</b><br />
Biochemistry BSc<br />
University of Manchester (UK)
