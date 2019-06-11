require 'jobs'

RSpec.describe "Jobs" do
  describe "#sort" do
    subject(:result) { Jobs.new.sort(input) }

    context "blank dependeny graph" do
      let(:input) { "" }

        it "returns an empty sequence" do
          is_expected.to be_empty
        end
      end

    context "given one job with no dependencies" do
      let(:input) do
        <<~INPUT
          a =>
        INPUT
      end
        it "returns the correct non-dependent job" do
          is_expected.to contain_exactly("a")
        end
      end

    context "given multiple jobs with no dependencies" do
      let(:input) do
        <<~INPUT
          a =>
          b =>
          c =>
        INPUT
      end
        it "returns the correct non-dependent jobs" do
          is_expected.to contain_exactly("a","b","c")
        end
      end

    context "given multiple jobs with one dependencies" do
      let(:input) do
        <<~INPUT
          a =>
          b => c
          c =>
        INPUT
      end
        it "returns the correct dependent job" do
          expect(result.index("c")).to be < result.index("b")
          is_expected.to contain_exactly("a","b","c")
        end
      end

    context "given multiple jobs with multiple dependencies" do
      let(:input) do
        <<~INPUT
          a =>
          b => c
          c => f
          d => a
          e => b
          f =>
        INPUT
      end
        it "returns the correct dependent jobs" do
          expect(result.index("a")).to be < result.index("d")
          expect(result.index("b")).to be < result.index("e")
          expect(result.index("c")).to be < result.index("b")
          expect(result.index("f")).to be < result.index("c")
          is_expected.to contain_exactly("a","b","c","d","e","f")
        end
      end

    context "given a graph containing a self-dependent job" do
      let(:input) do
        <<~INPUT
          a =>
          b =>
          c => c
        INPUT
      end
      it "raises a self-dependency error" do
        expect { subject }.to raise_error(Jobs::SelfDependencyError)
      end
    end

    context "given a graph containing circular dependencies" do
      let(:input) do
        <<~INPUT
          a =>
          b => c
          c => f
          d => a
          e =>
          f => b
        INPUT
      end

      it "raises a circular dependency error" do
        expect { subject }.to raise_error(Jobs::CircularDependencyError)
      end
    end
  end
end
