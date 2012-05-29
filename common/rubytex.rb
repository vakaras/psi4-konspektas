#! /usr/bin/ruby

require 'enumerator'

class Array
  def collect_inter(sep)
    out = "";
    each_with_index do |v, i|
      xo(sep) if i > 0;
      yield v;
    end;
    return out;
  end;

  def join2(l, s, r)
    "#{l}#{join(s)}#{r}"
  end;
end;

class String
  def xo
    out = gsub("&L", "[").gsub("&R", "]").gsub("&&", "&").gsub("&A", "@");
    $dst.write(" #{out} ");
  end;

  def h_mc(num)
    "\\multicolumn{#{num}} 
    {|>{\\columncolor[gray]{0.8}}c|}
    {\\bf #{self}}";
  end;
end;

class Table
  def initialize
    @align  = [];
    @header = [];
    @widths = [];
    @rows   = [];
    @line   = 1;
  end;

  def with
    yield

    "\\begin{longtable}".xo
    @align.each_index.map do |i|
      '%s{%f\linewidth}' % [@align[i], @widths[i]];
    end.join2('{|', ' | ', "|}\n").xo;

    "\\hline\n".xo
    @rows.each do |row|
      (row + "\n").xo
    end;
    "\\end{longtable}\n".xo
  end;

  def xrow_a(*y)
    @align = y;
  end;

  def xrow_h(*y)
    @rows << y.each_with_index.map do |cell, index| 
      "\\multicolumn{1}
      {|>{\\centering\\columncolor[gray]{0.8}}p{#{@widths[index]}\\linewidth}|}
      {\\textbf{#{cell}}}"
    end.join2("", " & ", "\\\\ \\hline");
  end;
  
  def xrow_hh(cell)
    @rows << 
      "\\multicolumn{#{@widths.length}} 
      {|>{\\columncolor[gray]{0.8}}c|}
      {\\bf #{cell}} \\\\ \\hline";
  end;

  # EVIL EVIL HACK
  def xrow_h2(*y)
    @rows << y.each_with_index.map do |cell, index| 
      width = @widths[index*2..index*2+1].inject(:+) * 1.06;
      "\\multicolumn{2}
      {|>{\\centering\\columncolor[gray]{0.8}}p{#{width}\\linewidth}|}
      {\\textbf{#{cell}}}"
    end.join2("", " & ", "\\\\ \\hline");
  end;
  
  def xrow_ee(cell)
    @rows << 
      "\\multicolumn{#{@widths.length}}
       {|p{0.96\\linewidth}|}
       {#{cell}} \\\\ \\hline";
  end;

  def xrow_e(*y)
    @rows << y.join2("", " & ", "\\\\ \\hline")
  end;

  def xrow_er0(r, c, *y)
    cell = "\\multirow{#{r}}{\\linewidth}{#{c}}";
    xrow_er1(cell, *y);
  end;

  def xrow_er1(*y)
    @rows << y.join2("", " & ", "\\\\ \\cline{2-3}")
  end;

  def xrow_er2(*y)
    @rows << y.join2("", " & ", "\\\\ \\hline")
  end;
  
  def xrow_ei(*y)
    y.unshift(@line.to_s);
    @line += 1;
    xrow_e(y);
  end;

  def xrow_w(*y)
    y           = y.map { |x| x.to_f }
    @widthMult  = 1 - 0.025 * y.length;
    sum         = y.inject(:+) / @widthMult;
    @widths     = y.map { |x| x / sum }
  end;

  def xrow_spec(*y)
    xrow_e(y[0].h_mc(1), y[1].h_mc(1), y[2].h_mc(5), y[3].h_mc(6), y[4].h_mc(1));
  end;

  # KLM BEGIN
  def klm_calc(seq)
    time = 0;
    seq.scan(/([0-9]*)([HKMP])/).each do |m|
      n     = m[0].empty? ? 1 : m[0].to_i
      c     = m[1]
      time += @klm[c] * n;
    end;
    return time;
  end;

  def xrow_klm0()
    @klm_time = 0;
    @klm      = {"K" => 0.2, "P" => 1.1, "H" => 0.4, "M" => 1.35};
  end;

  def xrow_klm1(annot, seq, comment = "")
    @klm_time += (time = klm_calc(seq));
    xrow_e(annot, seq, time.to_s);
  end;

  def xrow_klm2()
    xrow_e('\textbf{Iš viso}', "", '\textbf{%.2f}' % [@klm_time]);
  end;
  # KLM END
end; 

def xtable(src)
  z = src.split(']').map do |line|
    line.split('[', 2).map do |entry|
      entry.strip;
    end;
  end;

  (t = Table.new).with do
    z.reject! { |y| y.length < 2 }
    z.each do |y|
      arg = y[1].split('|', -1).map { |x| x.strip }
      sep = t.send("xrow_" + y[0], *arg);
      "\n".xo
    end;
  end;
end;

def main()
  src  = File.open("dist/input.tmp", "r");
  $dst = File.open("dist/output.tmp", "w");
  fun  = src.readline.strip;
  arg  = src.read.gsub('@', '\\');
  puts "READ: #{arg}"
  send(fun, arg);
  $dst.close
end;

main();
