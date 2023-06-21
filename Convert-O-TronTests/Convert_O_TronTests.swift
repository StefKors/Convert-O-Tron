//
//  Convert_O_TronTests.swift
//  Convert-O-TronTests
//
//  Created by Stef Kors on 21/06/2023.
//

import XCTest
@testable import Convert_O_Tron

final class Convert_O_TronTests: XCTestCase {

    func testXMLDocument() throws {
        guard let path = Bundle.main.url(forResource: "states", withExtension: "opml") else {
            return
        }
        let result = OPMLParser().parse(url: path)
        XCTAssertNotNil(result)
    }

    func testNestingWithSample() throws {
        let input = """
<?xml version="1.0" encoding="ISO-8859-1"?>
<opml version="2.0">
    <head>
        <title>states.opml</title>
        <dateCreated>Tue, 15 Mar 2005 16:35:45 GMT</dateCreated>
        <dateModified>Thu, 14 Jul 2005 23:41:05 GMT</dateModified>
    </head>
    <body>
        <outline text="United States">
            <outline text="Far West">
                <outline text="Alaska"/>
                <outline text="California"/>
            </outline>
        </outline>
    </body>
</opml>
"""

        let result = OPMLParser().parse(string: input)
        XCTAssertNotNil(result)
    }

    func testCommentWithSample() throws {
        let input = """
<?xml version="1.0" encoding="ISO-8859-1"?>
<opml version="2.0">
    <head>
        <title>states.opml</title>
        <dateCreated>Tue, 15 Mar 2005 16:35:45 GMT</dateCreated>
        <dateModified>Thu, 14 Jul 2005 23:41:05 GMT</dateModified>
    </head>
    <body>
        <outline text="United States">
            <outline text="Far West">
                <outline text="Changes" isComment="true">
                    <outline text="1/3/02; 4:54:25 PM by DW">
                        <outline text="Change &quot;playlist&quot; to &quot;radio&quot;."/>
                    </outline>
                    <outline text="2/12/01; 1:49:33 PM by DW" isComment="true">
                        <outline text="Test upstreaming by sprinkling a few files in a nice new test folder."/>
                    </outline>
                </outline>
            </outline>
        </outline>
    </body>
</opml>
"""

        let result = OPMLParser().parse(string: input)
        XCTAssertNotNil(result)
    }

    func testLinksWithSample() throws {
        let input = """
<?xml version="1.0" encoding="ISO-8859-1"?>
<opml version="2.0">
    <head>
        <title>states.opml</title>
        <dateCreated>Tue, 15 Mar 2005 16:35:45 GMT</dateCreated>
        <dateModified>Thu, 14 Jul 2005 23:41:05 GMT</dateModified>
    </head>
    <body>
        <outline text="Top 10 albums">
            <outline text="Mezmerize" created="Sun, 16 Oct 2005 05:56:10 GMT" type="link" url="http://google.com"/>
            <outline text="Hypnotize" created="Tue, 25 Oct 2005 21:33:28 GMT" type="link" url="http://yahoo.com"/>
        </outline>
    </body>
</opml>
"""

        let result = OPMLParser().parse(string: input)
        XCTAssertNotNil(result)
        if let result {
            let markdown = MarkdownGenerator().start(document: result)
            XCTAssert(!markdown.content.isEmpty)
        } else {
            XCTFail()
        }
    }

    func testHeadMetadata() throws {
        let input = """
<?xml version="1.0" encoding="ISO-8859-1"?>
<opml version="2.0">
    <head>
        <title>states.opml</title>
        <dateCreated>Tue, 15 Mar 2005 16:35:45 GMT</dateCreated>
        <dateModified>Thu, 14 Jul 2005 23:41:05 GMT</dateModified>
    </head>
    <body>
        <outline text="Top 10 albums">
            <outline text="Mezmerize" created="Sun, 16 Oct 2005 05:56:10 GMT" type="link" url="http://google.com"/>
            <outline text="Hypnotize" created="Tue, 25 Oct 2005 21:33:28 GMT" type="link" url="http://yahoo.com"/>
        </outline>
    </body>
</opml>
"""

        let result = OPMLParser().parse(string: input)
        XCTAssertNotNil(result)
        if let result {
            let markdown = MarkdownGenerator().start(document: result)
            XCTAssert(!markdown.content.isEmpty)
            XCTAssertEqual(markdown.title, "states.opml")
            XCTAssertEqual(markdown.dateCreated?.timeIntervalSince1970, 1110904545)
            XCTAssertEqual(markdown.dateModified?.timeIntervalSince1970, 1121384465)
        } else {
            XCTFail()
        }
    }

    func testDateParse() throws {
        let string = "Thu, 30 Jan 2019 09:35:45 GMT"
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        XCTAssertNotNil(formatter.date(from: string))
    }

    func testHeadings() throws {
        let input = """
<?xml version="1.0" encoding="ISO-8859-1"?>
<opml version="2.0">
  <head>
    <title>Heading 1</title>
  </head>
  <body>
    <outline text="Heading 2">
      <outline text="Heading 3">
        <outline text="Heading 4">
          <outline text="Heading 5">
            <outline text="Heading 6">
            </outline>
          </outline>
        </outline>
      </outline>
    </outline>
  </body>
</opml>
"""

        let result = OPMLParser().parse(string: input)
        XCTAssertNotNil(result)
        if let result {
            let markdown = MarkdownGenerator().start(document: result)
            XCTAssert(!markdown.content.isEmpty)
            XCTAssertEqual(markdown.title, "Heading 1")

            let expectedResult = """
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6
"""

            XCTAssertEqual(
                markdown.content.trimmingCharacters(in: .whitespacesAndNewlines),
                expectedResult.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        } else {
            XCTFail()
        }
    }

    func testIdent() throws {
        let input = """
<?xml version="1.0" encoding="ISO-8859-1"?>
<opml version="2.0">
  <head>
    <title>Heading 1</title>
  </head>
  <body>
    <outline text="Heading 2">
      <outline text="Heading 3">
        <outline text="Heading 4">
          <outline text="Heading 5">
            <outline text="Heading 6">
              <outline text="Indent 1">
                <outline text="Indent 2">
                  <outline text="Indent 3">
                    <outline text="Indent 4">
                      <outline text="Indent 5">
                        <outline text="Indent 6"></outline>
                      </outline>
                    </outline>
                  </outline>
                </outline>
              </outline>
            </outline>
          </outline>
        </outline>
      </outline>
    </outline>
  </body>
</opml>

"""

        let result = OPMLParser().parse(string: input)
        XCTAssertNotNil(result)
        if let result {
            let markdown = MarkdownGenerator().start(document: result)
            XCTAssert(!markdown.content.isEmpty)
            XCTAssertEqual(markdown.title, "Heading 1")

            let expectedResult = """
# Heading 1
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5
###### Heading 6
\t- Indent 1
\t\t- Indent 2
\t\t\t- Indent 3
\t\t\t\t- Indent 4
\t\t\t\t\t- Indent 5
\t\t\t\t\t\t- Indent 6
"""

            XCTAssertEqual(
                markdown.content.trimmingCharacters(in: .whitespacesAndNewlines),
                expectedResult.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        } else {
            XCTFail()
        }
    }

}
