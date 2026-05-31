require "spec_helper"

RSpec.describe FastComments::Jekyll::Util do
  describe ".escape_for_script" do
    it "escapes the five script-breaking characters" do
      expect(described_class.escape_for_script("<")).to eq('\\u003C')
      expect(described_class.escape_for_script(">")).to eq('\\u003E')
      expect(described_class.escape_for_script("&")).to eq('\\u0026')
      expect(described_class.escape_for_script(" ")).to eq('\\u2028')
      expect(described_class.escape_for_script(" ")).to eq('\\u2029')
    end

    it "leaves other characters (including non-ASCII) intact" do
      expect(described_class.escape_for_script("café")).to eq("café")
    end
  end

  describe ".escape_attr" do
    it "escapes & first, then quotes and angle brackets to entities" do
      expect(described_class.escape_attr("&\"<>")).to eq("&amp;&quot;&lt;&gt;")
    end
  end

  describe ".json_for_script" do
    it "produces space-free JSON matching JSON.stringify" do
      expect(described_class.json_for_script({ "a" => 1, "b" => "x" })).to eq('{"a":1,"b":"x"}')
    end

    it "escapes embedded closing script tags" do
      expect(described_class.json_for_script("</script>")).to eq('"\\u003C/script\\u003E"')
    end

    it "leaves non-ASCII literal" do
      expect(described_class.json_for_script("café")).to eq("\"café\"")
    end
  end

  describe ".get_cdn_base" do
    it "returns the EU CDN for the eu region" do
      expect(described_class.get_cdn_base("eu")).to eq("https://cdn-eu.fastcomments.com")
    end

    it "returns the default CDN otherwise" do
      expect(described_class.get_cdn_base(nil)).to eq("https://cdn.fastcomments.com")
      expect(described_class.get_cdn_base("us")).to eq("https://cdn.fastcomments.com")
    end
  end

  describe ".sanitize_config" do
    it "drops nil values and keeps scalars/arrays/hashes" do
      out = described_class.sanitize_config({ "a" => 1, "b" => nil, "c" => [1, 2], "d" => { "x" => 1 } })
      expect(out).to eq({ "a" => 1, "c" => [1, 2], "d" => { "x" => 1 } })
    end

    it "tolerates nil input" do
      expect(described_class.sanitize_config(nil)).to eq({})
    end
  end

  describe ".make_container_id" do
    it "builds a prefix-suffix id" do
      # Not stubbed here so we exercise the real implementation.
      allow(described_class).to receive(:make_container_id).and_call_original
      expect(described_class.make_container_id("fc")).to match(/\Afc-[0-9a-z]{7}\z/)
    end
  end
end
