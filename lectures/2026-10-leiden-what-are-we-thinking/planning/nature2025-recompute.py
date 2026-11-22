"""Recompute Nature 2025 AI-writing survey figures. Usage: python3 -I compute.py <xlsx>"""
import sys, pandas as pd
df = pd.read_excel(sys.argv[1], sheet_name='Data')
c = list(df.columns)
V1, V2, D2 = c[1], c[3], c[4]
COUNTRY, CAREER = c[18], c[21]
tick = lambda name: df[f'{name}:Which best describes your research field?'].notna()
AGG_SS = df['Social sciences:Aggregated research field'].notna()
print('Columns used:'); [print('  ', repr(x)) for x in (V1, D2, V2, COUNTRY, CAREER)]
# what makes up aggregated social sciences?
fields=['Economics','Psychology','Social sciences','Humanities','Other - Write In']
print('Aggregated SS n=', AGG_SS.sum(), '; overlap with ticks:', {f:int((AGG_SS & tick(f)).sum()) for f in fields})
print('Agg SS with none of Econ/Psych/SS/Hum ticked:', int((AGG_SS & ~(tick('Economics')|tick('Psychology')|tick('Social sciences')|tick('Humanities'))).sum()))
print('Any of Econ/Psych/SS/Hum ticked but not Agg SS:', int((~AGG_SS & (tick('Economics')|tick('Psychology')|tick('Social sciences')|tick('Humanities'))).sum()))
print('Humanities-only (no other field tick):', int((tick('Humanities') & (df.iloc[:,22:37].notna().sum(axis=1)==1)).sum()))
groups = {
 'Overall': pd.Series(True, index=df.index),
 'Humanities (tick)': tick('Humanities'),
 'Social sciences (tick)': tick('Social sciences'),
 'Social sciences (aggregated col)': AGG_SS,
 'Economics (tick)': tick('Economics'),
 'Psychology (tick)': tick('Psychology'),
 'Netherlands': df[COUNTRY].eq('Netherlands'),
 'PhD student': df[CAREER].eq('PhD student'),
}
def share(col, vals, g):
    s = df.loc[g, col].dropna(); n=len(s); k=s.isin(vals).sum()
    return k, n, 100*k/n
YN='Yes, without disclosing that I used AI'; YD='Yes, and I disclosed that I used AI'
print('\n1. Scenario 2 done-it-yourself')
print(f"{'group':34}{'grp N':>6}{'n ans':>7}{'anyYes':>8}{'%':>6}{'undiscl':>9}{'%':>6}{'discl':>7}{'%':>6}")
for g,m in groups.items():
    k,n,p=share(D2,[YN,YD],m); k1,_,p1=share(D2,[YN],m); k2,_,p2=share(D2,[YD],m)
    print(f"{g:34}{m.sum():6}{n:7}{k:8}{p:6.1f}{k1:9}{p1:6.1f}{k2:7}{p2:6.1f}")
print('\n2. Scenario 1 view: not appropriate under any circumstances')
for g in ['Overall','Humanities (tick)','Social sciences (tick)','Social sciences (aggregated col)','Netherlands','PhD student']:
    k,n,p=share(V1,["It's not appropriate under any circumstances"],groups[g]); print(f"{g:34}{k:6}/{n:<6}{p:6.1f}")
print("\n3. Scenario 2 view: It's appropriate")
for g in ['Overall','Humanities (tick)','Social sciences (tick)','Social sciences (aggregated col)','Netherlands','PhD student']:
    k,n,p=share(V2,["It's appropriate"],groups[g]); print(f"{g:34}{k:6}/{n:<6}{p:6.1f}")
