require 'shellwords'

module XCPretty
  module Printer

    class Simple
      
      include Printer

      PASS = "✓"
      FAIL = "✗"

      def pretty_format(text)
        case text
        when /^ProcessPCH/
          print_pch(text)
        when /^CompileC/
          print_compiling(text)
        when /^Clean.Remove/
          ""
        when /^Check dependencies/
          ""
        when /^=== CLEAN TARGET/
          print_clean_target(text)
        when /^=== BUILD TARGET/
          print_build_target(text)
        when /^PhaseScriptExecution/
          print_run_script(text)
        when /^Libtool/
          print_libtool(text)
        when /^CpResource/
          print_cpresource(text)
        when /^CopyStringsFile/
          print_copy_strings_file(text)
        when /^GenerateDSYMFile/
          print_generating_dsym(text)
        when /^ProcessInfoPlistFile/
          print_processing_info_plist(text)
        when /^Ld/
          print_linking(text)
        else
          ""
        end
      end

      def pretty_prefix
        "\n"
      end

      def print_linking(text)
        format("Linking", text.shellsplit[1].split('/').last)
      end

      def print_pch(text)
        format("Precompiling", Shellwords.shellsplit(text)[2])
      end

      def print_processing_info_plist(text)
        format("Processing", text.lines.first.shellsplit.last.split('/').last)
      end

      def print_compiling(text)
        format("Compiling", text.shellsplit[2].split('/').last)
      end

      def print_clean_target(text)
        info = project_build_info(text)
        format("Cleaning", "#{info[:project]}/#{info[:target]} [#{info[:configuration]}]")
      end

      def print_build_target(text)
        info = project_build_info(text)
        format("Building", "#{info[:project]}/#{info[:target]} [#{info[:configuration]}]")
      end

      def print_run_script(text)
        format("Running script", "'#{text.lines.first.shellsplit[1..-2].join(' ').gsub('\ ',' ')}'")
      end

      def print_libtool(text)
        format("Building library", text.shellsplit[1].split('/').last)
      end

      def print_cpresource(text)
        format("Copying", text.shellsplit[1])
      end

      def print_copy_strings_file(text)
        format("Copying", text.shellsplit.last.split('/').last)
      end

      def print_generating_dsym(text)
        format("Generating DSYM file")
      end

      def format(command, argument_text="", success=true)
        command_text = colorize? ? white(command) : command
        [status_symbol(success), command_text, argument_text].join(" ").strip
      end

      def status_symbol(success)
        if success && colorize?
          green(PASS)
        elsif colorize?
          red(FAIL)
        else
          ""
        end
      end
    end
  end
end
