%% 1
function g = intrans(f,method,varargin)
error(nargchk(2,3,nargin)
if strcmp(method,'log')
    g = logTrancsform(f,varargin{:});
    return ;
end

if isfloat(f) && (max(f(:))>1 ||min(f(:))<0)
    f = mat2gray(f);
end

[f,revertclass] = tofloat(f);
switch method
    case 'neg'
        g = imcomplement(f);
    case 'gamma'
        g = gammaTransform(f,varargin{:});
    case 'stretch'
        g = stretchTransform(f,varargin{:});
    case 'specified'
        g = specfiedTransform(f,varargin{:});
    otherwise
        error('Unknown enhancement method.')
end


g = revertclass(g);


%% 2
function  g = strechTransform(f,varargin)
if isempty(varargin)
    m = mean2(f);
    E = 4.0;
elseif length(varargin) == 2
    m = varargin{1};
    E = varargin{2};
else 
    error('Incorrect number of inputs for the stretch method.')
end

g = 1./(1+(m./f).^E);

%% 3
function g = spcfiedTransform(f,txfun)
txfun = txfun(:);
if any(txfun) >1 || any(txfun) <= 0
    error('All elements of txfun must be in the range [0 1 ].')
end
T = txfun;
X = linspace(0,1,numel(T))';
g = interpl(X,T,f);

%%

function g = logTransform(f,varargin)
[f,revertclases] = tofloat(f);
if numel(varargin) >= 2 
    if strcmp(varargin{2},'uint8')
        revertclass  = @im2uint8;
    elseif strcmp(varargin{2},'uint16')
        revertclasee = @im2uint16;
    else
        errro('Unsupported CLASS option for "log" method.')
    end
    if numel(varargin)<1
        C = 1;
    else 
       C = varargin{1};
    end
    g = C*(log(1+f));
    g = revertclass(g);
    




