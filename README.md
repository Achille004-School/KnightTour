# 🐴♞ Raw-Dogged Knight's Tour in RISC-V Assembly

> *Because sometimes you just gotta throw modern conveniences out the window and get down to the bare metal*

## What is this madness?

This is a completely over-engineered solution to the classic Knight's Tour problem, implemented in pure RISC-V assembly because... well, who does not like causing self-harm? 

![Sneaky meme](sneaky_meme.jpg)

## The Knight's Tour Problem

For the uninitiated: place a knight on a chessboard and try to visit every square exactly once using only legal knight moves (that funky L-shaped hop).

## Why Assembly? Why RISC-V?

**Bored**. **Speed**. **Practice**.  
..aaand if we want to say it, another complex project to confuse my friends with (hehe).

## Features

- ✅ Solves Knight's Tour on configurable board sizes (minimum 5x5)
- ✅ Pure RISC-V assembly with zero dependencies (not even sanity)
- ✅ Recursive backtracking algorithm that'll make your stack sweat
- ✅ Stack overflow protection (because we're reckless, not stupid)
- ✅ Runs on any RISC-V system or emulator
- ✅ Makes you question your life decisions

## Configuration and running

Check out `RUN.md` for the full setup guide.

Want to torture yourself with different board sizes? Edit the `.equ SZ, 5` line in `main.s`. 

**Pro tip**: The mathematical minimum is 5x5. Go smaller and watch the algorithm politely wasing your time. (i.e. it will run, won't do anything)

**Another pro tip**: For odd board sizes, start with an even numbered square. (Again, if you really don't want to stare at a blank terminal)

## Testing Your Solutions

Included with this masochistic adventure is `test.py`, a Python validator that'll tell you if your Knight's Tour solutions are actually valid or if you've been staring at garbage output.

**Features**:
- ✅ Validates knight's tour solutions for any board size
- ✅ Interactive input or load from file
- ✅ Pretty board visualization
- ✅ Detailed error reporting when your tours are broken

**Usage**:
```bash
python test.py
```

**Disclaimer**: The testing script is AI-generated and reviewed by me. But still, do not consider it as my own work. It's just here to save you from manually counting chess squares like some medieval mathematician.

## Contributing

Found a bug? Want to add features? Great! But remember:
- All contributions must maintain the "questionable life choices" aesthetic
- Comments should be either deeply technical or mildly sarcastic
- No Python rewrites (I didn't come this far only to see a library import and a line of code)

## License

See `LICENSE.md` - it's probably more readable than the assembly code.

## Final Thoughts

This was supposed to be a quick evening project. It was not quick. It was not one evening. But hey, now I can solve Knight's Tours at the ""speed of light"" while simultaneously questioning every decision that led me here.

*Enjoy responsibly.* ♞

---

**Disclaimer**: This project in general is highly sarcastic and it was born as a write-and-forget. If you want to explore projects of mine that I actually cure and mantain, I suggest going into my main profile `@Achille004`.