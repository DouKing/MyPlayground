//: [Previous](@previous)

import UIKit
import CommonCrypto

class Block {
  var index: Int = 0
  var dateCreated: String
  var previousHash: String!
  var hash: String!
  var nonce: Int

  var key: String {
    get {
      return String(self.index) + self.dateCreated + self.previousHash + String(self.nonce)
    }
  }

  init() {
    self.dateCreated = Date().toString()
    self.nonce = 0
  }
}

class Blockchain {
  private (set) var blocks = [Block]()

  init(_ genesisBlock: Block) {
    addBlock(genesisBlock)
  }

  func addBlock(_ block: Block) {
    if blocks.isEmpty {
      // 添加创世区块
      // 第一个区块没有 previous hash
      block.previousHash = "0"
      block.hash = generateHash(for: block)
    } else {
      let previousBlock = getPreviousBlock()
      block.previousHash = previousBlock.hash
      block.index = blocks.count
      block.hash = generateHash(for: block)
    }
    blocks.append(block)
    displayBlock(block)
  }

  private func getPreviousBlock() -> Block {
    return blocks[blocks.count - 1]
  }

  private func displayBlock(_ block: Block) {
    print("------ 第 \(block.index) 个区块 --------")
    print("创建日期：\(block.dateCreated)")
    print("Nonce：\(block.nonce)")
    print("前一个区块的哈希值：\(block.previousHash!)")
    print("哈希值：\(block.hash!)")
  }

  private func generateHash(for block: Block) -> String {
    var hash = block.key.sha1Hash()
    while !hash.hasPrefix("00") {
      block.nonce += 1
      hash = block.key.sha1Hash()
    }
    return hash
  }
}

extension String {
  func sha1Hash() -> String {
    let data = self.data(using: String.Encoding.utf8)!
    var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
    data.withUnsafeBytes {
      _ = CC_SHA1($0, CC_LONG(data.count), &digest)
    }
    let hexBytes = digest.map { String(format: "%02hhx", $0) }
    return hexBytes.joined()
  }
}

extension Date {
  func toString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: self)
  }
}

let block1 = Block()
let blockchain = Blockchain(block1)
for _ in 1...5 {
  let block = Block()
  blockchain.addBlock(block)
}


//: [Next](@next)
