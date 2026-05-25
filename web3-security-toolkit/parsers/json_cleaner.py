import json
import os
import sys
from datetime import datetime

def parse_slither(json_path):
    if not os.path.exists(json_path):
        print(f"[-] Error: No se encuentra el archivo {json_path}")
        return

    with open(json_path, 'r') as f:
        data = json.load(f)

    results = data.get('results', {}).get('detectors', [])
    
    print(f"\n### 🛡️ SECURITY TRIAGE REPORT - FILTERED BY ARCHITEC-SHADOW")
    print(f"Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
    print("| Severity | Vulnerability | Element Affected | Description |")
    print("|--- |--- |--- |--- |")

    critical_count = 0
    for vuln in results:
        # Filtrar solo impactos de cuidado: High, Medium o High-Impact lógicos
        severity = vuln.get('impact', 'Low')
        if severity in ['High', 'Medium']:
            critical_count += 1
            name = vuln.get('check', 'Unknown')
            description = vuln.get('description', '').replace('\n', ' ')
            first_element = vuln.get('elements', [{}])[0].get('name', 'Global/Multi-contract')
            
            print(f"| **{severity}** | {name} | `{first_element}` | {description} |")
            
    print(f"\n> **Triage Analytics:** Found {critical_count} actionable vulnerabilities requiring immediate engineering mitigation.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python3 json_cleaner.py ../raw_outputs/tu_archivo_slither.json")
    else:
        parse_slither(sys.argv[1])
