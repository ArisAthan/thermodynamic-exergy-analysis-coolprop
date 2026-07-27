# Dynamic Thermodynamic & Exergetic Analysis of Vapour Compression Cycles

## 📌 Project Overview
This repository presents a dynamic 24-hour transient thermodynamic and exergetic (2nd Law) simulation of a vapour compression refrigeration system utilizing **R600 (Isobutane)** as the working fluid. 

The model was programmed in **MATLAB** integrated with the **CoolProp** thermophysical property database to account for hourly ambient temperature fluctuations ($T_{amb}$) and dynamic operating conditions.

---

## 🔬 Computational Methodology & Thermodynamics
* **Fluid Property Engine:** Integrated **CoolProp** library within MATLAB scripts for high-accuracy state point evaluations ($h, s, p, T$)[cite: 2].
* **Transient Ambient Model:** Modeled hourly ambient temperature variations using a sinusoidal distribution[cite: 2]:
  $$T_{amb}(t) = T_m + \frac{DR}{2} \cdot \cos\left(2\pi \frac{t - 14}{24}\right)$$
* **Variable Compressor Efficiency:** Incorporated pressure-ratio dependent isentropic efficiency[cite: 2]:
  $$\eta_{is} = 0.874 - 0.0642 \cdot \pi_c, \quad \text{where } \pi_c = \frac{p_{high}}{p_{low}}$$
* **Motor & Mechanical Losses:** Factored electric motor efficiency ($\eta_{el} = 0.95$) into total hourly electrical power demand ($P_{el}$)[cite: 2].

---

## ⚖️ Exergy & 2nd Law Analysis
Beyond standard energy analysis (COP), the framework quantifies dynamic **Exergy Destruction ($\dot{Ex}_D$)** and dynamic **Exergetic Efficiency ($\eta_{ex}$)** across individual components[cite: 2]:

* **Useful Exergy Rate ($\dot{Ex}_u$):**
  $$\dot{Ex}_u = \dot{m}_{air,e} c_{p,air} \left[ (T_{air,in} - T_{air,out}) - T_0 \ln\left(\frac{T_{air,in}}{T_{air,out}}\right) \right]$$
* **Condenser Exergy Destruction ($\dot{Ex}_{D,cond}$):** Tracks irreversibilities caused by finite temperature differences during heat rejection to ambient air[cite: 2].
* **Evaporator Exergy Destruction ($\dot{Ex}_{D,evap}$):** Evaluates entropy generation during low-temperature thermal energy absorption[cite: 2].

---

## 📊 Key Results Snapshot
* **Average Daily COP:** Achieved $\overline{\text{COP}} = 5.21$ (exceeding ASHRAE Standard 90.1 baseline requirement of 2.966)[cite: 2].
* **Exergetic Efficiency ($\eta_{ex}$):** Ranged between **$14.6\%$ and $22.1\%$** across the 24-hour cycle, peaking during peak ambient temperature conditions[cite: 2].
* **Daily Energy Consumption:** Total work $W_{el,day} = 28.05 \text{ kWh/day}$ (Operating cost: **€5.61/day** at €0.20/kWh)[cite: 2].
* **Optimization Pathways:** Identified performance enhancement strategies including eco-friendly refrigerant replacement (R290/Propane), subcooling/superheating internal heat exchangers (IHX), and multi-stage compression[cite: 2].

---

## 📁 Repository Structure
```text
├── docs/
│   └── Thermodynamic_Exergy_Analysis_Report.pdf  # Complete Technical Report
└── README.md                                     # Technical Case Study Summary
