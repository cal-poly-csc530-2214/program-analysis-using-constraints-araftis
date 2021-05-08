//
//  main.swift
//  Lab4
//
//  Created by AJ Raftis on 4/27/21.
//

import Foundation
import SwiftZ3
import SwiftSyntax

print("Hello, World!")
testZ3()

//print("y: \(PV1(50))")
//print("y: \(PV1(-50))")

print(FileManager.default.currentDirectoryPath)
let url = URL(fileURLWithPath: "Lab4/PV1.swift", relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath))
do {
    let ast = try SyntaxParser.parse(url)
    print(ast)

    if let function = findFunction(named: "PV1", in: ast) {
        let cutPoints = findCutPoints(in: function)
        print("cut points:\n\(cutPoints)")
        //print("function: \(function.description)")
    }
} catch {
    print("error: \(error)")
}

func findFunction(named name: String, in ast: SyntaxProtocol, indent: Int = 0) -> FunctionDeclSyntax? {
    //print("\(String(repeating: "  ", count: indent)) \(ast.syntaxNodeType)")
    if let syntax = ast as? Syntax,
       let decl = FunctionDeclSyntax(syntax),
       decl.identifier.text == name {
        //dump(syntax: decl)
        return decl
    }
    for child in ast.children {
        if let found = findFunction(named: name, in: child, indent: indent + 1) {
            return found
        }
    }
    return nil
}

/**
 NOTE: This code is going to make a ton of assumptions...
 */
func findCutPoints(in function: FunctionDeclSyntax) -> [Any] {
    var cutPoints = [Any]()
    if let body = function.body {
        cutPoints.append(contentsOf: findCutPoints(in: body))
    }
    return cutPoints
}

func findCutPoints(in codeBlock: CodeBlockSyntax) -> [Any] {
    var cutPoints = [Any]()
    // We're basically going to loop over the children (recursively), looking for specific token types. For example, declarations, expressions and loops.
    for codeBlockItem in codeBlock.statements {
        cutPoints.append(contentsOf: findCutPoints(in: codeBlockItem))
    }
    return cutPoints
}

func findCutPoints(in codeBlockItem: CodeBlockItemSyntax) -> [Any] {
    var cutPoints = [Any]()
    //dump(syntax: codeBlockItem)
    if let variableDecl = VariableDeclSyntax(codeBlockItem.item) {
        if let cutPoint = cutPoint(from: variableDecl) {
            cutPoints.append(cutPoint)
        }
    }
    return cutPoints
}

func cutPoint(from decl: VariableDeclSyntax) -> Any? {
    // Not sure if it's overall relevant, but we can check decl.letOrVarKeyword to check in the declaration is mutable.
    //dump(syntax: decl)
    for child in decl.bindings {
        let id : String = child.pattern.description.trimmingCharacters(in: .whitespaces)
        if let initializer = child.initializer {
            return "true => I[\(initializer.value.description)/\(id)]"
        }
    }
    return nil
}

func dump(syntax item: SyntaxProtocol) -> Void {
    print("\(item.syntaxNodeType):")
    if let mirror = item as? CustomReflectable {
        for child in mirror.customMirror.children {
            print("   \(child.label ?? "nil"): \(child.value)")
        }
    }
}

func testZ3() -> Void {
    let config = Z3Config()
    config.setParameter(name: "model", value: "true")

    let context = Z3Context(configuration: config)

    let left = context.makeConstant(name: "left", sort: Float.self)
    let width = context.makeConstant(name: "width", sort: Float.self)
    let right = context.makeConstant(name: "right", sort: Float.self)

    let leftValue = left == 50.0
    let widthValue = width == 100.0

    let rightEq = right == left + width

    let solver = context.makeSolver()

    solver.assert([leftValue, widthValue, rightEq])
    print(solver.check())

    if let model = solver.getModel() {
        print(model.double(right), 150)
    } else {
        print("Failed!")
    }
}
