{r4 <- long; long handler; nop; nop}
{EHA <- r4; nop; nop; nop}
{b after; nop; nop; nop}

handler:
{r0 <- ec0; nop; nop; nop}
{r1 <- ec1; nop; nop; nop}
{r2 <- ec2; nop; nop; nop}
{r3 <- ec3; nop; nop; nop}
{r5 <- epc; nop; nop; nop}
{r8 <- r5 + 0x10; nop; nop; nop}
{epc <- r8; nop; nop; nop}
{r9 <- long; long 0xdeadbeef }
{eret; nop; nop; nop}

after:
{r6 <- 0xaf7; nop; nop; nop}
{syscall; r10 <- 1001}
{r7 <- 0xead}
