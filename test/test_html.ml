open Tyxml_test

let html_elements = "html elements", tyxml_tests Html.[

  "div",
  div [a []],
  "<div><a></a></div>" ;

  "a",
  canvas [a []],
  "<canvas><a></a></canvas>";

  "template",
  template ~a:[a_id "idtmpl"] [p [txt "Template"]],
  "<template id=\"idtmpl\"><p>Template</p></template>" ;

  "picture",
  div [
    picture ~a:[a_id "idpicture"]
      ~img:(img ~a:[a_id "idimg"] ~src:"picture/img.png" ~alt:"test picture/img.png" ()) [
        source ~a:[a_mime_type "image/webp"; a_src "picture/img1.webp"] ()
      ; source ~a:[a_mime_type "image/jpeg"; a_src "picture/img2.jpg"] ()
    ]
  ],
  {|<div><picture id="idpicture">|}
    ^ {|<img src="picture/img.png" alt="test picture/img.png" id="idimg"/>|}
    ^ {|<source type="image/webp" src="picture/img1.webp"/>|}
    ^ {|<source type="image/jpeg" src="picture/img2.jpg"/>|}
  ^ {|</picture></div>|} ;
]

let escaping = "html escaping", tyxml_tests Html.[

  "cdata",
  cdata "<bar>]]>foo<bar/>",
  {|
<![CDATA[
<bar>foo<bar/>
]]>
|} ;

  "cdata multi",
  cdata "<bar>]]>foo<b]]>ar/>",
  {|
<![CDATA[
<bar>foo<bar/>
]]>
|} ;

  "cdata_script" ,
  cdata_script "<bar>]]>foo<bar/>" ,
  {|
//<![CDATA[
<bar>foo<bar/>
//]]>
|} ;

  "cdata_style" ,
  cdata_style "<bar>]]>foo<bar/>" ,
  {|
/* <![CDATA[ */
<bar>foo<bar/>
/* ]]> */
|} ;

  "comment",
  tot (Xml.comment
         {|[if IE 8]> <html class="no-js lt-ie9" lang="en"> <![endif]|}),
  {|<!--[if IE 8]> <html class="no-js lt-ie9" lang="en"> <![endif]-->|} ;

  "dodgy comment 1",
  tot (Xml.comment {|><script BOUM/>|}),
  {|<!--&gt;<script BOUM/>-->|} ;

  "dodgy comment 2",
  tot (Xml.comment {|-><script BOUM/>|}),
  {|<!---&gt;<script BOUM/>-->|} ;

  "dodgy comment 3",
  tot (Xml.comment {|foo--><script BOUM/>|}),
  {|<!--foo--&gt;<script BOUM/>-->|} ;

  "dodgy comment 4",
  tot (Xml.comment {|foo--!><script BOUM/>|}),
  {|<!--foo--!&gt;<script BOUM/>-->|} ;

  "utf8",
  a ~a:[a_href "/text/λαμδα"] [txt "λαμδα"],
  {|<a href="/text/λαμδα">λαμδα</a>|} ;

]


let tests = [
  html_elements ;
  escaping ;
]

let () = Alcotest.run "tyxml" tests
