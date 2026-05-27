#!/bin/bash
# scripts/regenerate_data_model.sh
# Generates data model documentation from actual code and Supabase schema

OUTPUT="docs/DATA_MODEL_GENERATED.md"

echo "# Auto-Generated Data Model Summary" > "$OUTPUT"
echo "Generated: $(date)" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# Find all *_model.dart files and extract class definitions
find src/lib -name "*_model.dart" -type f | while read file; do
  echo "## $(basename $file)" >> "$OUTPUT"
  echo "" >> "$OUTPUT"
  echo '```dart' >> "$OUTPUT"
  grep -A 20 "^class " "$file" | head -30 >> "$OUTPUT"
  echo '```' >> "$OUTPUT"
  echo "" >> "$OUTPUT"
done

echo "✓ Generated $OUTPUT"
echo "✓ Compare with docs/DATA_MODEL_M3.adoc and update manually"
