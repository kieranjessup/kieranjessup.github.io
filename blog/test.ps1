# AC-2(9) testing
#     _ _____ ____ ____  _   _ ____  
#    | | ____/ ___/ ___|| | | |  _ \ 
# _  | |  _| \___ \___ \| | | | |_) |
#| |_| | |___ ___) |__) | |_| |  __/ 
# \___/|_____|____/____/ \___/|_|    

# Add necessary assemblies for Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$hostname = hostname

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Please enter your name"
$form.Size = New-Object System.Drawing.Size(350, 150)
$form.StartPosition = "CenterScreen"

# Create the text field
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Size = New-Object System.Drawing.Size(260, 20)
$textbox.Location = New-Object System.Drawing.Point(10, 20)
$form.Controls.Add($textbox)

# Create the button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Submit"
$button.Size = New-Object System.Drawing.Size(75, 23)
$button.Location = New-Object System.Drawing.Point(10, 50)
$form.Controls.Add($button)

# Add the event handler for the button click event
$button.Add_Click({
    $input = $textbox.Text
    if (-not [string]::IsNullOrEmpty($input)) {
        $source = "CustomEventSource"
        $logName = "Application"

        # Check if the event source exists, if not create it
        if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
            [System.Diagnostics.EventLog]::CreateEventSource($source, $logName)
            [System.Windows.Forms.MessageBox]::Show("Event source created successfully!", "Info", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }

        # Create a custom event in the Application log with event ID 9999
        Write-EventLog -LogName $logName -Source $source -EventId 9999 -EntryType Information -Message "Shared account ADMIN was logged into by $input on workstation: $hostname"

        # Show a confirmation message
        [System.Windows.Forms.MessageBox]::Show("Event created successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } else {
        # Show an error message if the text field is empty
        [System.Windows.Forms.MessageBox]::Show("Please enter some text.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Run the form
[void]$form.ShowDialog()
