---
description: Testing rules for test files, including boundaries and predictable time.
applyTo: "**/test/**,**/tests/**,**/__tests__/**,**/*.test.*,**/*.spec.*,**/*_test.*,**/test_*.py,**/*Test.java,**/*Tests.cs"
---

- Link tests to the task's acceptance criteria.
- Cover a normal case, invalid input, and exact boundaries where relevant.
- Use a controllable clock for time-based behaviour; do not rely on sleeps or the real current time.
- Derive expected answers from confirmed requirements, not from the current implementation.
- Do not weaken or skip tests to make them pass.
