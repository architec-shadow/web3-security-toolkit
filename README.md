# ⚙️ Web3 Security Tooling Orchestrator
> **Enterprise-grade automation pipeline running ephemeral, isolated security triage environments via Docker.**

---

## 🛠️ Overview

`web3-security-toolkit` is a high-efficiency security infrastructure component designed to orchestrate static analysis tools (**Slither** and **Aderyn AST Scanner**) inside strictly sandboxed, non-leaking environments. 

By utilizing containerized micro-services, this toolkit ensures deterministic execution, eliminates local dependency contamination, and leverages custom post-processing scripts to filter out analytical noise. The result is a hyper-fast, high-precision security triage pipeline engineered for high-stakes smart contract validation.

### Key Capabilities
* **Isolated Environment Sandboxing:** Ephemeral Docker containment protocols preventing environment leakage (Strict OpSec alignment).
* **Multi-Tool Orchestration:** Concurrent execution of Slither (Solidity control-flow analysis) and Aderyn (Rust-based Abstract Syntax Tree auditing).
* **Automated Noise Reduction:** Custom Python post-processing engines engineered to scrub false positives, isolating high and medium-severity vulnerabilities instantly.

---

## 🏗️ Architecture Blueprint

```text
[Target Smart Contracts] ──> Orchester Pipeline (tool_orchestrator.sh)
                                    │
                                    ├───> Ephemeral Docker Container [Slither]  ──> raw_outputs/slither.json
                                    ├───> Ephemeral Docker Container [Aderyn]   ──> raw_outputs/aderyn.md
                                    │
                                    └───> Post-Processor Triage (json_cleaner.py) ──> Actionable Markdown Report
