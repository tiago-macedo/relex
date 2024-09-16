require_relative '../spec_helper'
require 'relex'
include Relex

describe Lexer do
  before :each do
    @lexer = Lexer.new
  end

  describe "next_token" do
    it "returns EOF_TOKEN when the lexer has been assigned no input" do
      expect(@lexer.next_token).to eq(EOF_TOKEN)
    end

    it "returns EOF_TOKEN when there is no more input" do
      @lexer.start ""
      expect(@lexer.next_token).to eq(EOF_TOKEN)
    end

    # create specific error
    it "raises an error when remaining input is not matched by any rules" do
      @lexer.start "unmatched input"
      expect{ @lexer.next_token }.to raise_error(RuntimeError)
    end

    it "returns EOF_TOKEN when instructed to ignore everything" do
      @lexer.ignore /.*/
      @lexer.start "input to be ignored"
      expect(@lexer.next_token).to eq(EOF_TOKEN)
    end

    it "returns recognized keywords and finishes with EOF_TOKEN" do
      @lexer.ignore /\s+/
      @lexer.keyword :special
      @lexer.start " \t\nspecialspecial   special   "
      expect(@lexer.next_token).to eq(Token.new(:special, "special", 2, 0))
      expect(@lexer.next_token).to eq(Token.new(:special, "special", 2, 7))
      expect(@lexer.next_token).to eq(Token.new(:special, "special", 2, 17))
      expect(@lexer.next_token).to eq(EOF_TOKEN)
    end

    it "returns tokens matched by regular rules and finishes with EOF_TOKEN" do
      @lexer.ignore /\s+/
      @lexer.rule :word, /\w+/
      @lexer.start "sentence with four tokens"
      expect(@lexer.next_token).to eq(Token.new(:word, "sentence", 1, 0))
      expect(@lexer.next_token).to eq(Token.new(:word, "with", 1, 9))
      expect(@lexer.next_token).to eq(Token.new(:word, "four", 1, 14))
      expect(@lexer.next_token).to eq(Token.new(:word, "tokens", 1, 19))
      expect(@lexer.next_token).to eq(EOF_TOKEN)
    end

    it "returns all types of tokens and finishes with EOF_TOKEN" do
      @lexer.ignore /\s+/
      @lexer.keyword :if
      @lexer.keyword :lparen, "("
      @lexer.keyword :rparen, ")"
      @lexer.rule :word, /\w+/
      @lexer.start "ifu ( if ) ifu"
      expect(@lexer.next_token).to eq(Token.new(:word, "ifu", 1, 0))
      expect(@lexer.next_token).to eq(Token.new(:lparen, "(", 1, 4))
      expect(@lexer.next_token).to eq(Token.new(:if, "if", 1, 6))
      expect(@lexer.next_token).to eq(Token.new(:rparen, ")", 1, 9))
      expect(@lexer.next_token).to eq(Token.new(:word, "ifu", 1, 11))
      expect(@lexer.next_token).to eq(EOF_TOKEN)
    end

    it "recognizes keywords even if declared after rules which also match" do
      @lexer.ignore /\s+/
      @lexer.rule :word, /\w+/
      @lexer.keyword :keyword
      @lexer.start "word keyword keywordmore"
      expect(@lexer.next_token).to eq(Token.new(:word, "word", 1, 0))
      expect(@lexer.next_token).to eq(Token.new(:keyword, "keyword", 1, 5))
      expect(@lexer.next_token).to eq(Token.new(:word, "keywordmore", 1, 13))
      expect(@lexer.next_token).to eq(EOF_TOKEN)
    end
  end
end
