$boundary_filename = File.join(File.dirname(__FILE__), '../boundary_file.json')
$boundary_file = File.read($boundary_filename)
$boundary_hash = JSON.parse($boundary_file)
