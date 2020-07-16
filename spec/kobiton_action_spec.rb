describe Fastlane::Actions::KobitonAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The kobiton plugin is working!")

      Fastlane::Actions::KobitonAction.run(nil)
    end
  end
end
