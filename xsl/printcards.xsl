<?xml version="1.0" encoding="UTF-8"?>

<!-- Format query results for display -->

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    
    <xsl:template match="/">
      <html>
      <head>
      <style>
div.pagebreak {
  page-break-after: always;
}
div.card-front {
  height: 1.5in;
  width: 2in;
  float: left;
  border: solid black 1px;
  padding: 0px;
  text-align: center;
}
div.card-back {
  height: 1.5in;
  width: 2in;
  float: right;
  padding: 0px;
  text-align: center;
}
table.card-contents {
  height: 100%;
  width: 100%;
}
div.spacer {
  clear: both;
}
span.xlit {
  font-family: Transliteration, Helvetica;
}
span.trans {
  font-weight: bold;
}
body {
  margin-left: .7in;
  margin-right: .7in;
  padding: 0px;
}
</style>
</head>
      <body>
      <xsl:variable name="cards-per-page" select="18"/>
      <xsl:variable name="pagecount" select="ceiling(count(words/word) div $cards-per-page)" />
      <xsl:call-template name="do-page">
        <xsl:with-param name="page" select="$pagecount" />
        <xsl:with-param name="cards-per-page" select="$cards-per-page" />
      </xsl:call-template>
      </body>
      </html>
    </xsl:template>

    <xsl:template name="do-page">
      <xsl:param name="page"/>
      <xsl:param name="cards-per-page"/>
      <xsl:call-template name="both-sides">
         <xsl:with-param name="start-card" select="($page - 1) * $cards-per-page"/>
         <xsl:with-param name="end-card" select="$page * $cards-per-page"/>
      </xsl:call-template>

      <xsl:if test="$page > 1">
        <div class="spacer"></div>
        <div class="pagebreak"></div>
        <xsl:call-template name="do-page">
          <xsl:with-param name="page" select="$page - 1"/>
          <xsl:with-param name="cards-per-page" select="$cards-per-page" />
        </xsl:call-template>
      </xsl:if>
    </xsl:template>

    <xsl:template name="both-sides">
      <xsl:param name="start-card"/>
      <xsl:param name="end-card"/>

      <xsl:apply-templates select="words/word[position() > $start-card and position() &lt;= $end-card]" mode="fronts"/>

      <div class="spacer"></div>
      <div class="pagebreak"></div>

      <xsl:apply-templates select="words/word[position() > $start-card and position() &lt;= $end-card]" mode="backs"/>

    </xsl:template>

    <xsl:template match="word" mode="fronts">
<div class="card-front">
<table class="card-contents"><tr><td align="center" valign="middle">
<span class="xlit"><xsl:value-of select="xlit"/></span><br/>
<span class="trans"><xsl:value-of select="trans"/></span>
</td></tr></table>
</div>
    </xsl:template>

    <xsl:template match="word" mode="backs">
<xsl:variable name="filename" select="image"/>
<div class="card-back">
<table class="card-contents"><tr><td align="center" valign="middle">
<img src="../images/inverted/{$filename}"/>
</td></tr></table>
</div>
    </xsl:template>

</xsl:stylesheet>