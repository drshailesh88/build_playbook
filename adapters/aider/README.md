# Aider Adapter

Use your Build Playbook with Aider for budget-friendly code building.

## Prerequisites

```bash
pip install aider-chat
```

## Configure Your Model

### GLM-5 (Zhipu AI)
```bash
export OPENAI_API_BASE=https://api.z.ai/api/paas/v4/
export OPENAI_API_KEY=your-zhipu-key
aider --model openai/glm-5
```

### DeepSeek (cheapest option — $0.28/M tokens)
```bash
export DEEPSEEK_API_KEY=your-key
aider --model deepseek/deepseek-chat
```

## The Workflow

### Running a Grilling Session

```bash
# Aider can read your playbook workflow files
aider --read playbook/workflows/3-data-grill.md \
      --message "Follow the data grill instructions and interview me about my app"
```

### Building from .planning/ Files

```bash
# After your grilling sessions produced .planning/ files:
aider --read .planning/REQUIREMENTS.md \
      --read .planning/ROADMAP.md \
      --message "Read the requirements and build the first unchecked requirement"
```

### Overnight Loop (Simple Ralph Script)

```bash
# Run from your project directory:
./adapters/aider/overnight.sh 20 glm-5
```

## When to Use Aider vs GSD v2

- **Aider**: Simple tasks, pair programming, quick fixes. You stay in the loop.
- **GSD v2**: Full overnight autonomy with crash recovery and cost tracking.

For overnight building, GSD v2 is better. For daytime coding with a cheap model, Aider is great.
