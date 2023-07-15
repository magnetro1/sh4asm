import * as vscode from "vscode";
import * as staticData from "./sh4asm_staticData";
import * as path from "path";

import { MVC2GEN_CONSTANTS } from "./sh4asm_staticData";
import { stages_Hex_2_Names } from "./sh4asm_staticData";
import { ASM_DEF } from "./sh4asm_staticData";



const thumbsPath = "supportMedia/characterThumbnails";
const stagesPath = "supportMedia/stagesThumbnails";

export function activate(context: vscode.ExtensionContext) {
  let disposable = vscode.commands.registerCommand("sh4asm.helloWorld", () => {
    vscode.window.showInformationMessage("Hello World from sh4asm-ts!");
  });

  let box = vscode.commands.registerCommand("sh4asm.box", function () {
    // Get the active text editor
    let editor = vscode.window.activeTextEditor;
    if (editor) {
      // Get the document, then the selection, then the text
      let doc = editor.document;
      let selection = editor.selection;
      let txt = doc.getText(selection);
      // Surround the selected text with box characters
      let surroundChar = ";*************************************\n";
      let boxText = txt
        .split("\n")
        .map((str) => {
          return surroundChar + str + "\n" + surroundChar;
        })
        .join("");
      // Replace the selection with box text
      editor.edit((editBuilder) => {
        editBuilder.replace(selection, boxText);
      });
    }
  });

  context.subscriptions.push(disposable);
  context.subscriptions.push(box);

  // Hover stage definition
  vscode.languages.registerHoverProvider("sh4asm", {
    provideHover(document, position, token) {
      const range = document.getWordRangeAtPosition(position, /0x0[a-zA-Z](?=.*stage)|0x\d+\w+(?=.*stage)|0x\d+\d+(?=.*stage)/gi);
      const word = document.getText(range).toLocaleLowerCase();
      // Create hover for stage image
      const imageMD = new vscode.MarkdownString();
      imageMD.baseUri = vscode.Uri.file(
        path.join(context.extensionPath, stagesPath, path.sep)
      );
      let imageHover = imageMD.appendMarkdown(`![stage](${imageMD.baseUri}/${word}_thumb.png)`
      );
      let dataMD = new vscode.MarkdownString();
      dataMD.appendMarkdown(`\n\nName: ${stages_Hex_2_Names[word]}\n\n`);
      dataMD.appendCodeblock(`Hex: ${word}`, "sh4asm");
      dataMD.appendCodeblock(`Decimal: ${parseInt(word, 16)}`, "sh4asm");
      const dataHover = dataMD;

      // Return hover if stage is found
      if (Object.keys(staticData.characters_Hex_2_Names).includes(word)) {
        return new vscode.Hover([imageHover, dataHover]);
      }
    }
  });
  // Hover character definition
  vscode.languages.registerHoverProvider("sh4asm", {
    provideHover(document, position, token) {
      const range = document.getWordRangeAtPosition(
        position,
        /0x\d+\w+(?=.*char)|0x\d+\d+(?=.*char)/gi
      );
      const word = document.getText(range);
      // Hex math for character assist values
      let hexPrefix = "0x";
      let baseVal = parseInt(word, 16);
      // let assistA: number | string = 0; // doesn't need to be calculated
      let assistB: number | string = 0;
      let assistC: number | string = 0;
      assistB = baseVal + 64;
      assistB = assistB.toString(16);
      assistC = baseVal + 128;
      assistC = assistC.toString(16);
      // Create hover for character image
      let imageMD = new vscode.MarkdownString();
      imageMD.baseUri = vscode.Uri.file(
        path.join(context.extensionPath, thumbsPath, path.sep)
      );
      // let imageHover = imageMD.appendMarkdown(`<img src="${imageMD.baseUri}/charID_${word}.jpg" width="25">`);
      // imageHover.supportHtml = true;
      let imageHover = imageMD.appendMarkdown(
        `![char](${imageMD.baseUri}/charID_${word}.jpg)`
      );

      let dataMD = new vscode.MarkdownString();
      dataMD.appendMarkdown(
        `\n\nName: ${staticData.characters_Hex_2_Names[word]}\n\n`
      );
      dataMD.appendCodeblock(`Hex: ${word}`, "sh4asm");
      dataMD.appendCodeblock(`Decimal: ${parseInt(word, 16)}`, "sh4asm");

      dataMD.appendCodeblock(`Assist - α: ${word}`, "sh4asm");
      dataMD.appendCodeblock(`Assist - β: ${hexPrefix + assistB}`, "sh4asm");
      dataMD.appendCodeblock(`Assist - γ: ${hexPrefix + assistC}`, "sh4asm");

      // dataMD.appendMarkdown(`\n\n\*Name:\* ${staticData.characters_Hex_2_Names[word]}`);
      const dataHover = dataMD;
      if (Object.keys(staticData.characters_Hex_2_Names).includes(word)) {
        return new vscode.Hover([imageHover, dataHover]);
      }
    },
  });
  // Hover ASM_DEF definitions
  vscode.languages.registerHoverProvider("sh4asm", {
    provideHover(document, position, token) {
      const range = document.getWordRangeAtPosition(position);
      const range2 = document.getWordRangeAtPosition(
        position,
        /([a-zA-Z]+[a-zA-Z_\\_0-9]+)+:/
      );
      const range3 = document.getWordRangeAtPosition(position, /#align\w+/);
      const range4 = document.getWordRangeAtPosition(position, /@\w+|@.*/);
      const word = document.getText(range);
      if (Object.keys(ASM_DEF).includes(word)) {
        return new vscode.Hover(ASM_DEF[word]);
      }
      if (range2) {
        return new vscode.Hover(ASM_DEF["label"]);
      }
      if (range3) {
        return new vscode.Hover(ASM_DEF["#align"]);
      }
      if (range4) {
        return new vscode.Hover(ASM_DEF["@"]);
      }
    },
  });

  // Auto suggest completion using the MVC2GEN_CONSTANTS; for JS files
  vscode.languages.registerCompletionItemProvider({
    scheme: "file",
    language: "javascript",
  },
    {
      provideCompletionItems(document, position, token, context) {
        let completionItems: vscode.CompletionItem[] = [];
        for (let key in MVC2GEN_CONSTANTS) {
          let completionItem = new vscode.CompletionItem(
            MVC2GEN_CONSTANTS[key]
          );
          completionItem.insertText = MVC2GEN_CONSTANTS[key];
          completionItem.kind = vscode.CompletionItemKind.Text;
          completionItems.push(completionItem);
        }
        return completionItems;
      },
    },
    "."
  );
}
export function deactivate() { }
