<?xml version="1.0" encoding="UTF-8"?>

<!-- Format query results for display -->

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    
    <xsl:template match="/">
       <html>
       <head>
<script language="javascript">

var cards = Array(<xsl:apply-templates select="words/word" mode="numbers"/>);



var currentCard = cards.shift();

function getRandom(low, high) {
  i = Math.floor(Math.random() * (high - low)) + low;
  return i;
}

function insertCard(arr, element, position) {
  // special case: first element
  if (position &lt;= 0) {
    arr.unshift(element);
    return arr;
  }
  if (position >= arr.length -1) {
    arr.push(element);
    return arr;
  }
  else {
    for (i = arr.length;i >= position;i--) {
      if (i == position) {
        arr[i] = element;
      }
      else {
        arr[i] = arr[i-1];
      }
    }
  }
}   

function showAnswer() {
  document.getElementById("a" + currentCard).style.visibility="visible";
}

function nextCard(confidence) {
  // make the current card invisible
  document.getElementById("q" + currentCard).style.visibility="hidden";
  document.getElementById("a" + currentCard).style.visibility="hidden";

  // -1 means "drop this card"
  if (confidence != -1) {
    // move the current card to a new position.
    // if confidence is low, move it close to the front
    // if confidence is high, move it to the back
    position = Math.floor((confidence / 100) * cards.length);

    // mix things up a bit
    position += Math.floor(getRandom(-confidence/2, confidence/2));

    // put currentCard into cards at position
    insertCard(cards, currentCard, position);
  }

  // DEBUG
  //cardsText = "";
  //for (i=0;i&lt;cards.length;i++) {
  //  cardsText += cards[i] + " ";
  //}

  //document.getElementById("cards_info").innerHTML = cardsText;

  // get a new card
  currentCard = cards.shift();
  document.getElementById("q" + currentCard).style.visibility="visible";
}

</script>


<style type="text/css">
#cards_info {
  position: absolute;
  left: 20px; top: 300px;
  visibility: visible;
}

#buttons {
  background-color: #ffffff;
  position: absolute;
  left: 20px; top: 140px;
  visibility: visible;
  text-align: left;
}

.text {
  font-family: verdana, arial, helvetica;
  font-size: 12px;
}

div.xlit {
  font-family: Transliteration, helvetica;
}

div.translation {
  font-weight: bold;
}

<xsl:apply-templates select="words/word" mode="classes"/>

</style>

       </head>
       <body>
       <xsl:apply-templates select="words/word" mode="divs" />

<div id="buttons"><span class="text">
(<a class="text" onclick="javascript:showAnswer()" href="#">reveal answer</a>)
(<a class="text" onclick="javascript:nextCard(-1)" href="#">remove card</a>)
<br/>
Confidence:

[no idea]
<a class="text" onclick="javascript:nextCard(10)" href="#">1</a>&#160;
<a class="text" onclick="javascript:nextCard(25)" href="#">2</a>&#160;
<a class="text" onclick="javascript:nextCard(50)" href="#">3</a>&#160;
<a class="text" onclick="javascript:nextCard(75)" href="#">4</a>&#160;
<a class="text" onclick="javascript:nextCard(100)" href="#">5</a>&#160;
[I know that!]

</span>
</div>

<div id="cards_info">

</div>

       </body>
       </html>
    </xsl:template>

    <xsl:template match="word[position()=1]" mode="classes">

#q<xsl:value-of select="position()"/> {
  width: 100%;
  background-color: #ffffff;
  position: absolute;
  left: 20px; top: 20px;
  visibility: visible;
}

#a<xsl:value-of select="position()"/> {
  background-color: #ffffff;
  position: absolute;
  left: 20px; top: 80px;
  visibility: hidden;
}
       
    </xsl:template>

    <xsl:template match="word" mode="classes">

#q<xsl:value-of select="position()"/> {
  width: 100%;
  background-color: #ffffff;
  position: absolute;
  left: 20px; top: 20px;
  visibility: hidden;
}

#a<xsl:value-of select="position()"/> {
  background-color: #ffffff;
  position: absolute;
  left: 20px; top: 80px;
  visibility: hidden;
}
       
    </xsl:template>

    <xsl:template match="word[position()=1]" mode="numbers">
       <xsl:text>"</xsl:text><xsl:value-of select="position()"/><xsl:text>"</xsl:text>
    </xsl:template>

    <xsl:template match="word" mode="numbers">
       <xsl:text>, "</xsl:text><xsl:value-of select="position()"/><xsl:text>"</xsl:text>
    </xsl:template>

    <xsl:template match="word" mode="divs">
       <div id="q{position()}">
       <xsl:apply-templates select="image"/>
       </div>
       <div id="a{position()}">
       <div class="xlit"><xsl:value-of select="xlit"/></div>
       <div class="translation"><xsl:value-of select="trans"/></div>
       </div>
    </xsl:template>

    <xsl:template match="image">
       <xsl:variable name="filename" select="."/>
       <img src="../images/{$filename}" />
    </xsl:template>

</xsl:stylesheet>