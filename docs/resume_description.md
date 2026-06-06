# Resume Description

## 中文版

**RIS/FAS 可重构无线动态信道建模与容量分析平台 | MATLAB**

- 构建面向 RIS-V2V 与 FAS-UAV 场景的 MATLAB 仿真平台，统一动态信道生成、
  参数实验、结果保存和自动测试流程。
- 实现空间 CCF、时间 ACF、频率 FCF、RIS 参数扫描、车辆运动状态分析以及
  阵列域/波束域容量一致性验证。
- 实现 BDCM 能量集中度和稀疏性指标，并采用一致的系数数量比较完整 GBSM、
  完整 BDCM 与 95% 能量稀疏 BDCM 的计算复杂度。
- 实现 FAS-UAV 动态 LoS/NLoS 信道、有效端口选择、建模误差、不同孔径和
  运动状态下的容量分析，以及 FAS 与 ULA 性能比较。
- 建立可重复的 Monte Carlo 配置、MATLAB 自动测试和 GitHub 项目文档。

## English Version

**Reconfigurable Wireless Dynamic Channel Modeling and Capacity Analysis | MATLAB**

- Built a self-contained MATLAB simulator for RIS-enabled V2V and FAS-assisted
  UAV dynamic wireless channels.
- Implemented spatial CCF, temporal ACF, frequency FCF, RIS parameter sweeps,
  mobility analysis, and array/beam-domain capacity invariance checks.
- Quantified beam-domain energy concentration and compared full-model and
  sparsity-aware operation counts on a consistent coefficient basis.
- Implemented dynamic FAS-UAV channel generation, active-port selection,
  modeling-error analysis, aperture and mobility experiments, and FAS/ULA
  capacity comparison.
- Added reproducible Monte Carlo profiles, automated numerical tests, generated
  figures, MAT outputs, and GitHub documentation.

## Interview Talking Points

- Why RIS/FAS mobile channels are non-stationary.
- What spatial CCF, temporal ACF, and frequency FCF measure.
- Why a unitary DFT preserves ideal MIMO capacity.
- How beam-domain sparsity can reduce practical computation.
- Why FAS modeling error uses raw CIRs while capacity uses normalized channels.
