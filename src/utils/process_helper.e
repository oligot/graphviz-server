note
	description: "Summary description for {PROCESS_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROCESS_HELPER

feature -- Access	

	output_of_command (a_cmd: READABLE_STRING_8; a_dir: detachable READABLE_STRING_GENERAL): detachable STRING
			-- Output of command `a_cmd' launched in directory `a_dir'.
		require
			cmd_attached: a_cmd /= Void
		local
			pf: PROCESS_FACTORY
			p: PROCESS
			retried: BOOLEAN
			err: BOOLEAN
		do
			if not retried then
				err := False
				create Result.make (10)
				create pf
				p := pf.process_launcher_with_command_line (a_cmd, a_dir)
				p.set_hidden (True)
				p.set_separate_console (False)
				p.redirect_input_to_stream
				p.redirect_output_to_agent (agent  (res: STRING; s: STRING)
					do
						res.append_string (s)
					end (Result, ?)
				)
				p.redirect_error_to_same_as_output
				p.launch
				p.wait_for_exit
			else
				err := True
			end
		rescue
			retried := True
			retry
		end

end