require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module ActiveDotfile
  describe FilenameHelper do
    subject { FilenameHelper.new "name" }

    before do
      subject.stub!(:home_directory).and_return("/home/user")
      subject.stub!(:project_root).and_return("/project/root")
    end

    describe "#existing_filename" do
      it "should return the filename if it exists" do
        filename = "/home/user/.name"
        File.should_receive(:exists?).with(filename).and_return(true)
        subject.existing_filename(filename).should == filename
      end

      it "should return nil if the filename does not exist" do
        File.should_receive(:exists?).with("/home/user/.name").and_return(false)
        subject.home_directory_file.should be_nil
      end
    end

    specify "#home_directory_file should check to see if the home directory file exists" do
      subject.should_receive(:existing_filename).with("/home/user/.name")
      subject.home_directory_file
    end

    describe "#project_root_file" do
      it "should check to see if the file exists" do
        subject.should_receive(:existing_filename).with("/project/root/.name")
        subject.project_root_file
      end

      it "should not check if no project root is detected" do
        subject.stub!(:project_root).and_return(nil)
        subject.should_not_receive(:existing_filename)
        subject.project_root_file
      end
    end

    describe "#configuration_files" do
      it "should return the files in priority order" do
        subject.stub! :project_root_file => 2,
                      :home_directory_file => 3,
                      :environment_file => 1
        subject.configuration_files.should == [3,2,1]
      end
    end

    specify "#environment_key should return the uppercase name concatenated with CONFIG_FILE" do
      subject.environment_key.should == "NAME_CONFIG_FILE"
    end

  end 
end
